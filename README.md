# 🌐 Static Website Hosting on AWS S3 using Terraform

Deploy a static website on **Amazon S3 using Terraform** with automated infrastructure provisioning, public access configuration, bucket policy management, and website file deployment.

This project demonstrates how **Infrastructure as Code (IaC)** can be used to provision and manage an AWS S3 static website.

---

## 🚀 Project Overview

The infrastructure is provisioned using Terraform and includes:

* Amazon S3 bucket
* Globally unique bucket name using Terraform Random Provider
* S3 public access configuration
* S3 bucket policy
* HTML website deployment
* CSS stylesheet deployment
* Terraform outputs
* AWS CLI verification

### Architecture

```text
                    ┌──────────────────────┐
                    │      Web Browser     │
                    │   HTTP/HTTPS Request │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │       AWS S3          │
                    │   Static Website      │
                    │       Bucket          │
                    └──────────┬───────────┘
                               │
                 ┌─────────────┴─────────────┐
                 ▼                           ▼
          ┌─────────────┐             ┌─────────────┐
          │ index.html  │             │  styles.css │
          └─────────────┘             └─────────────┘

                     ▲
                     │
              Infrastructure
               Provisioning
                     │
                     ▼
              ┌─────────────┐
              │  Terraform  │
              └─────────────┘
```

---

## 🛠️ Technologies Used

| Technology    | Purpose                        |
| ------------- | ------------------------------ |
| **Terraform** | Infrastructure as Code         |
| **AWS S3**    | Static website hosting         |
| **AWS IAM**   | Authentication and permissions |
| **AWS CLI**   | AWS resource verification      |
| **HTML**      | Website structure              |
| **CSS**       | Website styling                |
| **Git**       | Version control                |
| **GitHub**    | Source code management         |

---

## 📁 Project Structure

```text
Static-Web-Site-Hosting/
│
├── main.tf
├── index.html
├── styles.css
└── README.md
```

> Terraform state files and the `.terraform` directory are intentionally excluded from GitHub.

Recommended `.gitignore`:

```text
.terraform/
*.tfstate
*.tfstate.*
terraform.tfvars
.terraform.lock.hcl
```

---

# ⚙️ Deployment Guide

## Step 1 — Install Terraform

Verify Terraform installation:

```bash
terraform version
```

Example:

```text
Terraform v1.15.3
on windows_amd64
```

---

## Step 2 — Configure AWS CLI

Verify AWS CLI:

```bash
aws --version
```

Configure your AWS credentials:

```bash
aws configure
```

Provide:

```text
AWS Access Key ID
AWS Secret Access Key
Default region: ap-south-1
Default output format: json
```

Verify your AWS identity:

```bash
aws sts get-caller-identity
```

This confirms that the AWS CLI is authenticated successfully.

---

# Step 3 — Create the Terraform Project

Create the project directory:

```bash
mkdir project-static-website
cd project-static-website
```

Create the following files:

```text
main.tf
index.html
styles.css
```

Final structure:

```text
project-static-website/
│
├── main.tf
├── index.html
└── styles.css
```

---

# Step 4 — Configure Terraform Providers

The project uses the:

* AWS provider
* Random provider

Example Terraform configuration:

```hcl
terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }

  }
}

provider "aws" {
  region = "ap-south-1"
}
```

The AWS Mumbai region is:

```text
ap-south-1
```
