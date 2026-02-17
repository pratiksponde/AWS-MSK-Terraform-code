# 🚀 AWS MSK Using Terraform: Multi-Environment Deployment Guide

This repository contains Terraform infrastructure code to deploy **Amazon MSK Serverless** across multiple environments such as **Dev** and **UAT** using a modular and scalable architecture.

It provisions networking, security, IAM roles, MSK Serverless cluster, and a Kafka client EC2 instance to enable secure Kafka communication.

📖 **Full article:**  
https://dev.to/pratik_26/deploying-amazon-msk-serverless-across-multiple-environments-with-terraform-2i8c

---

# 🏗️ Architecture Overview

The infrastructure created by this project includes:

- VPC with public and private subnets
- Internet Gateway and routing
- Amazon MSK Serverless cluster
- EC2 instance as Kafka client
- IAM roles and policies
- Security groups
- Remote Terraform state stored in S3

---

# 📂 Repository Structure
```text
AWS-MSK-Terraform-code/
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── msk/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   │
│   └── uat/
│       ├── backend.tf
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variables.tf
│
└── README.md
```


---

# ⚙️ Features

- Modular Terraform architecture
- Amazon MSK Serverless provisioning
- Multi-environment deployment support
- Secure IAM authentication
- Kafka client EC2 instance
- Remote state management using S3
- Fully automated infrastructure

---


---

# 🔒 Security Best Practices

- IAM roles used instead of access keys
- Secure Kafka authentication using IAM
- Private subnet deployment
- Controlled security group access
- Remote state locking

---

# 🌎 Multi-Environment Support

Supported environments:

- Dev
- UAT
- Production (extendable)

Each environment has:

- Separate state file
- Separate configuration
- Independent infrastructure

---

# 📈 Benefits

- Infrastructure as Code
- Reusable modules
- Secure Kafka deployment
- Scalable architecture
- Easy environment management

---

# 👨‍💻 Author

**Pratik Ponde**  
Cloud & DevOps Engineer  

Article:  
https://dev.to/pratik_26/deploying-amazon-msk-serverless-across-multiple-environments-with-terraform-2i8c

---

# ⭐ Support

If you found this helpful:

- Star this repository
- Fork this repository
- Contribute improvements
