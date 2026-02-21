# 🚀 Guía Rápida - EC2 Pública con Terraform

## ✅ Configuración: EC2 Pública + Linux AWS

Este template crea una **EC2 PÚBLICA** con **Amazon Linux 2** en AWS, elegible para free tier.

### 🌐 Características de Red

- ✅ **IP Pública Estática**: Elastic IP asignada
- ✅ **Subnet Pública**: `map_public_ip_on_launch = true`
- ✅ **Internet Gateway**: Conectividad total a internet
- ✅ **Route Table Pública**: Rutas configuradas para internet
- ✅ **Security Group**: Puertos 22, 80, 443 abiertos

### 🐧 Sistema Operativo

- **Amazon Linux 2** (AWS Linux - optimizado para EC2)
- **Gratis en free tier**
- **Apache Web Server** instalado automáticamente
- **Actualizaciones automáticas** de sistema

## 📋 Paso a Paso (5 minutos)

### 1. Crear clave SSH

```bash
aws ec2 create-key-pair --key-name mi-clave --region us-east-1 --query 'KeyMaterial' --output text > mi-clave.pem
chmod 600 mi-clave.pem
```

### 2. Clonar y configurar

```bash
cd /workspaces/IAC/AWS
cp terraform.tfvars.example terraform.tfvars
# Editar si es necesario
```

### 3. Desplegar

```bash
terraform init
terraform plan
terraform apply
```

Tipo `yes` cuando se pida confirmación.

### 4. Obtener IP Pública

```bash
terraform output instance_public_ip
```

### 5. Conectarse

```bash
# SSH
ssh -i mi-clave.pem ec2-user@<IP-PUBLICA>

# Web (en navegador)
http://<IP-PUBLICA>
```

## 🔍 Verificar Configuración Pública

### Desde Terraform

```bash
# Ver toda la información
terraform output

# Solo IP pública
terraform output instance_public_ip

# URL web
terraform output web_server_url

# Comando SSH
terraform output ssh_command
```

### Desde AWS Console

1. Ve a **EC2 > Instances**
2. Busca tu instancia
3. Verifica:
   - **Public IPv4 address** ✅ (debe tener IP)
   - **Subnet** debe ser pública
   - **Security Group** permite puerto 80, 443, 22

## 💰 Free Tier

- EC2 t2.micro: 750 horas/mes
- VPC, Subnets, IGW: Gratis
- Elastic IP: Gratis (cuando está asociada)
- Apache: Gratis
- **Total estimado: $0** (si no excedes los límites)

## 🧹 Limpiar (Detener Cargos)

```bash
terraform destroy
```

Tipo `yes` para confirmar.

## 🐛 Troubleshooting

| Problema | Solución |
|----------|----------|
| No hay IP pública | `terraform apply` de nuevo, espera 2 min |
| No se conecta HTTP | Espera 3-5 min a que Apache inicie |
| SSH timeout | Verifica Security Group permite puerto 22 |
| Clave SSH no funciona | Verifica permisos: `chmod 600 mi-clave.pem` |

## 📚 Archivos del Template

- **main.tf** - Infraestructura (VPC, EC2, etc.)
- **variables.tf** - Variables configurables
- **outputs.tf** - IPs y datos de salida
- **user_data.sh** - Script de inicialización
- **terraform.tfvars.example** - Ejemplo de valores

## 🔗 Enlaces Útiles

- [AWS Free Tier](https://aws.amazon.com/free/)
- [EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**¡Tu EC2 pública está lista para usar!**
