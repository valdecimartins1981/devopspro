# Azure Red Hat OpenShift (ARO) — Terraform

Provisiona um cluster **Azure Red Hat OpenShift (ARO)** para uso em estudos via Terraform.

## 📁 Estrutura

```
aro-openshift/
├── main.tf           # Recursos principais (RG, VNet, Subnets, SP, Cluster)
├── variables.tf      # Declaração de variáveis
├── outputs.tf        # Outputs do cluster
├── providers.tf      # Configuração dos providers
└── terraform.tfvars  # Valores das variáveis (editar antes de aplicar)
```

## ✅ Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.3.0
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- [OpenShift CLI (oc)](https://docs.openshift.com/container-platform/4.13/cli_reference/openshift_cli/getting-started-cli.html)
- Subscription Azure com permissões de **Owner** ou **Contributor + User Access Administrator**

## 🚀 Como usar

### 1. Autenticar e registrar providers

```bash
az login
az account set --subscription "<seu-subscription-id>"

az provider register -n Microsoft.RedHatOpenShift --wait
az provider register -n Microsoft.Compute --wait
az provider register -n Microsoft.Storage --wait
az provider register -n Microsoft.Authorization --wait
```

### 2. Editar variáveis

Edite o arquivo `terraform.tfvars` com o seu `subscription_id` e, opcionalmente, o `pull_secret`.

> O Pull Secret é obtido em: https://console.redhat.com/openshift/install/pull-secret

### 3. Provisionar

```bash
terraform init
terraform plan -out=plano.tfplan
terraform apply plano.tfplan
```

> ⏱️ O cluster leva aproximadamente **35–45 minutos** para ficar pronto.

### 4. Acessar o cluster

```bash
# Obter credenciais do kubeadmin
az aro list-credentials \
  --name aro-estudos \
  --resource-group rg-aro-estudos

# Login via CLI
oc login <api_server_url> -u kubeadmin -p <password>

# Ou obter a URL do console
terraform output console_url
```

### 5. Destruir após os estudos (evitar custos)

```bash
terraform destroy
```

## 💰 Estimativa de Custo (East US)

| Recurso     | Tamanho          | Custo/hora aprox. |
|-------------|------------------|-------------------|
| 3x Masters  | Standard_D8s_v3  | ~$1.15/h          |
| 3x Workers  | Standard_D4s_v3  | ~$0.57/h          |
| **Total**   |                  | **~$1.72/h**      |

> 💡 **Dica:** Destrua o cluster quando não estiver usando para evitar custos desnecessários.

## ⚠️ Observações

- O campo `domain` deve ser **único** por subscription.
- Mínimo de **3 worker nodes** é obrigatório no ARO.
- A versão do OpenShift pode ser ajustada em `cluster_profile.version` no `main.tf`.
- O `pull_secret` é opcional, mas recomendado para acesso a imagens Red Hat oficiais.
