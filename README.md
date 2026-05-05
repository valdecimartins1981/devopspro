# Estrutura criada para treinamento e demos baseado na trilha do treinamento DEVOPS PRO

# devopspro

## Cloud providers structure

```
cloud-providers/
├── aws/                            # ← Full Terraform module structure
│   ├── modules/
│   │   ├── vpc/
│   │   ├── ec2/
│   │   ├── s3/
│   │   ├── rds/
│   │   ├── eks/
│   │   ├── iam/
│   │   └── security-group/
│   ├── environments/
│   │   ├── dev/
│   │   ├── uat/
│   │   └── prod/
│   ├── catalog-info.yaml           # Backstage IDP catalog
│   └── .port/entity.json          # Port.io IDP entity
├── azure/
├── digital-ocean/
├── gcp/
└── oci/
```

See [cloud-providers/aws/README.md](./cloud-providers/aws/README.md) for full documentation.
