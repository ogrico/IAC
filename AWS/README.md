# AWS EC2 Public Instance - Terraform Template

This Terraform template deploys a publicly accessible EC2 instance on AWS using **free tier eligible resources**.

## 🎯 What Gets Deployed

- **VPC** - Isolated virtual network
- **Public Subnet** - With internet access
- **Internet Gateway** - Enables public connectivity
- **EC2 Instance** (t2.micro) - Free tier eligible
- **Security Group** - Controls inbound/outbound traffic
- **Elastic IP** - Static public IP address
- **Apache Web Server** - Installed via user data script

## 💰 Free Tier Eligibility

The following resources are eligible for AWS free tier (12-month):
- **EC2 t2.micro**: 750 hours/month
- **VPC, Subnets, Internet Gateway**: Free
- **Elastic IPs**: Free when associated with a running instance
- **Data Transfer**: First 100 GB/month free

**Restrictions to avoid charges:**
- Only use `t2.micro` instance type
- Keep instance stopped when not in use (unused hours don't count)
- Watch data transfer; AWS charges for data OUT to the internet

## 📋 Prerequisites

1. **AWS Account** with free tier eligibility
2. **Terraform** >= 1.0 installed locally
3. **AWS CLI** configured with credentials
4. **SSH Key Pair** created in your AWS region

### Create SSH Key Pair (AWS Console or CLI)

```bash
aws ec2 create-key-pair --key-name my-key --region us-east-1 --query 'KeyMaterial' --output text > my-key.pem
chmod 600 my-key.pem
```

## 🚀 Deployment Steps

### 1. Initialize Terraform

```bash
cd AWS
terraform init
```

### 2. Create terraform.tfvars File

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to customize (optional):
```hcl
aws_region         = "us-east-1"
project_name       = "my-project"
instance_type      = "t2.micro"
allowed_ssh_cidr   = ["your-ip/32"]  # Replace with your IP for security
```

### 3. Plan Deployment

```bash
terraform plan
```

Review the resources that will be created.

### 4. Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted. This will take 2-3 minutes.

### 5. Get Instance Information

After deployment, Terraform outputs the following:
- **Instance ID**: Unique identifier for your instance
- **Public IP**: Use this to SSH and access the web server
- **SSH Command**: Ready-to-use command to connect

```bash
terraform output
```

## 🔌 Connect to Your Instance

### SSH Connection

```bash
ssh -i my-key.pem ec2-user@<instance-public-ip>
```

### Access Web Server

Open your browser:
```
http://<instance-public-ip>
```

You'll see the welcome page confirming the instance is running.

## 🛑 Destroy Resources (Stop Charges)

When done, destroy to avoid unexpected charges:

```bash
terraform destroy
```

Type `yes` to confirm deletion.

## 📁 File Structure

```
AWS/
├── main.tf                      # Main infrastructure definition
├── variables.tf                 # Input variables
├── outputs.tf                   # Output values
├── user_data.sh                 # Script run on instance startup
├── terraform.tfvars.example     # Example variables file
└── README.md                    # This file
```

## ⚙️ Customization

### Change Instance Type
Edit `variables.tf` or `terraform.tfvars`:
```hcl
instance_type = "t2.small"  # Still free tier eligible
```

### Change Region
```hcl
aws_region = "eu-west-1"    # Choose your region
```

### Restrict SSH Access (RECOMMENDED FOR PRODUCTION)
Edit `terraform.tfvars`:
```hcl
allowed_ssh_cidr = ["203.0.113.5/32"]  # Your IP only
```

### Modify User Data Script
Edit `user_data.sh` to install different software or run custom commands.

## 🔐 Security Best Practices

1. **Restrict SSH**: Change `allowed_ssh_cidr` to your IP instead of `0.0.0.0/0`
2. **Use Security Groups**: Already configured but review as needed
3. **Keep Key Safe**: Never commit SSH keys to Git
4. **Delete When Unused**: Unused instances still incur charges
5. **Monitor Costs**: Watch AWS Console for unexpected usage

## 🐛 Troubleshooting

### Connection Timeout
- Check security group allows SSH (port 22)
- Verify SSH key permissions: `chmod 600 my-key.pem`
- Check instance is running: `terraform show`

### Terraform Apply Fails
- Verify AWS credentials are configured: `aws sts get-caller-identity`
- Check IAM permissions (need EC2, VPC, IAM permissions)
- Ensure region is set correctly

### Web Server Not Responding
- Instance might still be initializing (2-3 minutes)
- Check security group allows HTTP (port 80)
- SSH in and check Apache: `sudo systemctl status httpd`

## 📚 Useful Commands

```bash
# View all outputs
terraform output

# Get specific output
terraform output instance_public_ip

# Refresh state without changes
terraform refresh

# Validate configuration syntax
terraform validate

# Format code
terraform fmt

# Destroy specific resource
terraform destroy -target=aws_instance.web
```

## 🔗 Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [EC2 Free Tier Details](https://aws.amazon.com/free/compute/)

## 📝 Notes

- This template uses Amazon Linux 2 (free tier eligible)
- Elastic IPs are free when associated with a running instance
- Data transfer charges apply to outbound data
- t2.micro is limited to 1 GB RAM (sufficient for testing)

## 🤝 Contributing

Feel free to modify and improve this template for your needs!

---

**Last Updated:** 2026
**Terraform Version:** >= 1.0
**AWS Provider Version:** >= 5.0
