resource "azurerm_log_analytics_workspace" "this" {
  name                = "law-${var.environment}-devopspro"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Automation Account for AKS/DB VM start/stop schedule
resource "azurerm_automation_account" "this" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

# Runbook: Start AKS node pools
resource "azurerm_automation_runbook" "aks_start" {
  name                    = "Start-AKS-NodePools"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell"
  tags                    = var.tags

  content = <<-SCRIPT
    param(
      [Parameter(Mandatory=$true)]
      [string]$ResourceGroupName,
      [Parameter(Mandatory=$true)]
      [string]$ClusterName
    )

    Connect-AzAccount -Identity

    $nodePool = Get-AzAksNodePool -ResourceGroupName $ResourceGroupName -ClusterName $ClusterName
    foreach ($pool in $nodePool) {
      Update-AzAksNodePool -ResourceGroupName $ResourceGroupName `
        -ClusterName $ClusterName `
        -Name $pool.Name `
        -NodeCount $pool.Count
      Write-Output "Started node pool: $($pool.Name)"
    }
  SCRIPT
}

# Runbook: Stop AKS node pools (scale to 0)
resource "azurerm_automation_runbook" "aks_stop" {
  name                    = "Stop-AKS-NodePools"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell"
  tags                    = var.tags

  content = <<-SCRIPT
    param(
      [Parameter(Mandatory=$true)]
      [string]$ResourceGroupName,
      [Parameter(Mandatory=$true)]
      [string]$ClusterName
    )

    Connect-AzAccount -Identity

    $nodePool = Get-AzAksNodePool -ResourceGroupName $ResourceGroupName -ClusterName $ClusterName
    foreach ($pool in $nodePool) {
      Update-AzAksNodePool -ResourceGroupName $ResourceGroupName `
        -ClusterName $ClusterName `
        -Name $pool.Name `
        -NodeCount 0
      Write-Output "Stopped node pool: $($pool.Name)"
    }
  SCRIPT
}

# Schedule: Start at 07:00 on weekdays
resource "azurerm_automation_schedule" "start" {
  name                    = "aks-start-schedule"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Week"
  interval                = 1
  timezone                = "E. South America Standard Time"
  start_time              = "${formatdate("YYYY-MM-DD", timestamp())}T07:00:00+00:00"
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

# Schedule: Stop at 20:00 on weekdays
resource "azurerm_automation_schedule" "stop" {
  name                    = "aks-stop-schedule"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Week"
  interval                = 1
  timezone                = "E. South America Standard Time"
  start_time              = "${formatdate("YYYY-MM-DD", timestamp())}T20:00:00+00:00"
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

resource "azurerm_automation_job_schedule" "aks_start" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.start.name
  runbook_name            = azurerm_automation_runbook.aks_start.name

  parameters = {
    resourcegroupname = var.resource_group_name
    clustername       = var.aks_cluster_name
  }
}

resource "azurerm_automation_job_schedule" "aks_stop" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  schedule_name           = azurerm_automation_schedule.stop.name
  runbook_name            = azurerm_automation_runbook.aks_stop.name

  parameters = {
    resourcegroupname = var.resource_group_name
    clustername       = var.aks_cluster_name
  }
}

# Grant Automation Account Contributor role on the AKS cluster
resource "azurerm_role_assignment" "automation_aks" {
  scope                = var.aks_cluster_id
  role_definition_name = "Azure Kubernetes Service Contributor Role"
  principal_id         = azurerm_automation_account.this.identity[0].principal_id
}
