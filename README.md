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

---

# Step 5 — Generate a Unique Bucket ID

S3 bucket names must be **globally unique**.

Terraform generates a random ID using the Random provider:

```hcl
resource "random_id" "rand_id" {
  byte_length = 8
}
```

The generated ID is added to the bucket name.

Example:

```text
website234-bucket-9440ee318e312fd8
```

---

# Step 6 — Create the S3 Bucket

Terraform creates the S3 bucket:

```hcl
resource "aws_s3_bucket" "website234_bucket" {
  bucket = "website234-bucket-${random_id.rand_id.hex}"
}
```

The resulting bucket name will look similar to:

```text
website234-bucket-9440ee318e312fd8
```

---

# Step 7 — Configure Public Access

For this demonstration, public access blocking is disabled so that the bucket policy can allow public object access.

```hcl
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.website234_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

### ⚠️ Security Notice

This configuration intentionally makes the website objects publicly accessible.

**Do not use a public S3 bucket configuration for sensitive, confidential, or private data.**

For production workloads, consider using **CloudFront + private S3 access** instead of exposing the S3 bucket directly.

---

# Step 8 — Create the S3 Bucket Policy

The bucket policy allows public read access to website objects:

```hcl
resource "aws_s3_bucket_policy" "website234" {
  bucket = aws_s3_bucket.website234_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"

        Resource = "arn:aws:s3:::${aws_s3_bucket.website234_bucket.id}/*"
      }
    ]
  })
}
```

The important permission is:

```text
s3:GetObject
```

This allows visitors to read the website files stored in the bucket.

---

# Step 9 — Upload `index.html`

Terraform uploads the website's HTML file:

```hcl
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website234_bucket.bucket
  source = "./index.html"
  key    = "index.html"
}
```

---

# Step 10 — Upload `styles.css`

Terraform uploads the CSS stylesheet:

```hcl
resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.website234_bucket.bucket
  source = "./styles.css"
  key    = "styles.css"
}
```

The S3 bucket will contain:

```text
index.html
styles.css
```

---

# Step 11 — Configure Terraform Output

Terraform can display the generated random ID:

```hcl
output "name" {
  value = random_id.rand_id.hex
}
```

Example:

```text
name = "9440ee318312fd8"
```

---

# Step 12 — Initialize Terraform

Initialize the Terraform project:

```bash
terraform init
```

Terraform downloads the required providers:

```text
hashicorp/aws
hashicorp/random
```

---

# Step 13 — Format Terraform Configuration

Format the Terraform files:

```bash
terraform fmt
```

This applies Terraform's standard formatting.

---

# Step 14 — Validate the Configuration

Validate the Terraform configuration:

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

---

# Step 15 — Create a Terraform Plan

Review the infrastructure changes before deployment:

```bash
terraform plan
```

Terraform displays the resources it intends to:

* Create
* Modify
* Destroy

Example:

```text
Plan: X to add, 0 to change, 0 to destroy.
```

> The exact number depends on the resources defined in the current Terraform configuration.

---

# Step 16 — Deploy the Infrastructure

Apply the Terraform configuration:

```bash
terraform apply
```

Terraform asks for confirmation:

```text
Do you want to perform these actions?
```

Enter:

```text
yes
```

Example:

```text
Apply complete! Resources: X added, 0 changed, 0 destroyed.
```

---

# Step 17 — Verify the S3 Bucket

List your S3 buckets:

```bash
aws s3 ls
```

Example:

```text
website234-bucket-9440ee318e312fd8
```

Check the contents of the bucket:

```bash
aws s3 ls s3://website234-bucket-9440ee318e312fd8
```

Expected:

```text
index.html
styles.css
```

---

# Step 18 — Access the Website

The uploaded HTML file can be accessed using the S3 object URL:

```text
https://<bucket-name>.s3.ap-south-1.amazonaws.com/index.html
```

Example:

```text
https://website234-bucket-9440ee318e312fd8.s3.ap-south-1.amazonaws.com/index.html
```

### 🌐 Live Website

The deployed website displays:

> **This is a Design Version V8**

> **Welcome to Terraform Tutorials**

---

# 🔄 Terraform Workflow

The complete deployment workflow is:

```text
Developer
    │
    ▼
Write Terraform Code
    │
    ▼
terraform init
    │
    ▼
terraform fmt
    │
    ▼
terraform validate
    │
    ▼
terraform plan
    │
    ▼
terraform apply
    │
    ▼
AWS S3 Infrastructure
    │
    ├── S3 Bucket
    ├── Public Access Configuration
    ├── Bucket Policy
    ├── index.html
    └── styles.css
    │
    ▼
Public Website
```

---

# 🧹 Destroy Infrastructure

When the project is no longer required, Terraform can remove the infrastructure:

```bash
terraform destroy
```

Confirm with:

```text
yes
```

This removes the AWS resources managed by the Terraform configuration.

---

# 📌 Key Terraform Commands

| Command              | Purpose                             |
| -------------------- | ----------------------------------- |
| `terraform init`     | Initialize Terraform                |
| `terraform fmt`      | Format Terraform files              |
| `terraform validate` | Validate configuration              |
| `terraform plan`     | Preview infrastructure changes      |
| `terraform apply`    | Create/update infrastructure        |
| `terraform output`   | Display Terraform outputs           |
| `terraform show`     | Display Terraform state information |
| `terraform destroy`  | Remove infrastructure               |

---

# 🎯 Project Objectives

This project demonstrates practical knowledge of:

* Infrastructure as Code
* Terraform providers
* Terraform resources
* Terraform variables and expressions
* Random resource generation
* AWS S3
* S3 bucket policies
* AWS IAM permissions
* AWS CLI
* Static website deployment
* Terraform state management
* Git and GitHub

---

# 🔐 Security Considerations

This project intentionally demonstrates a publicly readable S3 bucket.

For production environments:

* Avoid public S3 buckets where possible
* Store sensitive data in private buckets
* Use CloudFront for public website delivery
* Use Origin Access Control (OAC)
* Follow the principle of least privilege
* Never commit AWS access keys to GitHub
* Add Terraform state files to `.gitignore`
* Use IAM roles instead of long-lived credentials where possible

---

# 👨‍💻 Author

**Aniket Chatur**

DevOps / Cloud / SRE Engineer

GitHub: `chaturaniket7793-beep`

---

## ⭐ Project Highlights

```text
Infrastructure as Code
        ↓
Terraform
        ↓
AWS S3
        ↓
Static Website
        ↓
HTML + CSS
        ↓
Public Web Access
```

If you found this project useful, consider giving the repository a ⭐ on GitHub.
