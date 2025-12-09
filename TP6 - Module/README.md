# TP 6 - Modules Terraform

Ce projet démontre l'utilisation des modules Terraform pour déployer une infrastructure Azure de manière modulaire et réutilisable.

## Structure

```
TP6 - Module/
├── modules/
│   ├── rg/              # Module Resource Group
│   ├── network/         # Module Virtual Network et Subnet
│   ├── nsg/             # Module Network Security Group
│   ├── ip/              # Module Public IP et Network Interface
│   ├── storage/         # Module Storage Account
│   └── vm/              # Module Virtual Machine
├── prod/                # Configuration PRODUCTION (Standard_D2_v2)
│   ├── main.tf
│   └── provider.tf
└── dev/                 # Configuration DEV (Standard_D1_v2)
    ├── main.tf
    └── provider.tf
```

## Modules disponibles

### 1. **rg** - Resource Group
Crée un groupe de ressources Azure.
- Variables: `rg-location`
- Outputs: `resource_group_name`, `resource_group_id`, `location`

### 2. **network** - Virtual Network
Crée un réseau virtuel avec un subnet.
- Variables: `rg-name`, `rg-location`, `network-address`
- Outputs: `vnet_id`, `subnet_id`

### 3. **nsg** - Network Security Group
Crée un groupe de sécurité réseau avec des règles HTTP et SSH.
- Variables: `web_server_port`, `ssh_server_port`
- Outputs: `nsg_id`

### 4. **ip** - Public IP & Network Interface
Crée une adresse IP publique et une interface réseau.
- Variables: `resource_group_name`, `location`, `sku`, `tags`
- Outputs: `public_ip_address`, `network_interface_id`

### 5. **storage** - Storage Account
Crée un compte de stockage avec un conteneur.
- Variables: `rg-name`, `rg-location`, `container_access_type`
- Outputs: `storage_account_id`

### 6. **vm** - Virtual Machine
Crée une machine virtuelle Linux avec nginx.
- Variables: `rg-name`, `rg-location`, `interface-id`, `instance_template`
- Outputs: `vm_id`, `vm_size`

## Déploiement

### Environnement PROD (Standard_D2_v2)

```bash
cd prod
terraform init
terraform validate
terraform plan
terraform apply
```

### Environnement DEV (Standard_D1_v2)

```bash
cd dev
terraform init
terraform validate
terraform plan
terraform apply
```

## Vérification

Après le déploiement, vous pouvez vérifier que les VMs ont bien les bonnes tags et tailles :

```bash
# Pour PROD
az vm show -g prod-rg -n tftraining-vm --query "tags"
az vm show -g prod-rg -n tftraining-vm --query "hardwareProfile.vmSize"

# Pour DEV
az vm show -g dev-rg -n tftraining-vm --query "tags"
az vm show -g dev-rg -n tftraining-vm --query "hardwareProfile.vmSize"
```

## Destruction des ressources

Pour supprimer toutes les ressources :

```bash
# Pour PROD
cd prod
terraform destroy

# Pour DEV
cd dev
terraform destroy
```

## Notes

- Les deux environnements utilisent des modules identiques mais avec des configurations différentes.
- La taille de la VM est définie par le paramètre `instance_template` (Standard_D2_v2 pour prod, Standard_D1_v2 pour dev).
- Les ressources incluent automatiquement nginx qui est installé via l'extension de VM personnalisée.
- Le compte de stockage est configuré avec accès privé par défaut.
