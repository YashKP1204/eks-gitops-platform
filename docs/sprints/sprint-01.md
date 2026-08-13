# Sprint 1 Review & Sprint 2 Roadmap — AWS Networking and EKS Foundation

## Sprint 1 Status

**Status:**  Completed

**Primary Deliverable:** Terraform foundation established.

---

# What We Achieved

## Repository Structure

```text
terraform/
│
├── modules/
│
└── environments/
    └── dev/
        ├── main.tf
        ├── providers.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Terraform Workflow Established

```text
Terraform Code
        │
        ▼
terraform init
        │
        ▼
terraform validate
        │
        ▼
terraform fmt
        │
        ▼
terraform plan
        │
        ▼
terraform apply
```

---

## AWS Provider Configuration

We established the AWS provider and verified that Terraform could communicate with AWS.

---

## Infrastructure as Code Principles Reinforced

We intentionally avoided:

* Manual resource creation
* AWS Console dependency
* Hardcoded values
* Hardcoded credentials

Instead, we introduced:

* Variables
* Reusable configuration
* Environment-based infrastructure
* Predictable infrastructure creation

---

# Sprint 1 Lessons Learned

## Terraform Does Not Create Infrastructure Immediately

```text
Terraform Configuration
          │
          ▼
terraform plan
          │
          ▼
Execution Plan
          │
          ▼
terraform apply
          │
          ▼
AWS API
          │
          ▼
Infrastructure
```

---

## The Importance of `terraform plan`

`terraform plan` answers an extremely important question:

> "If I apply this configuration, what exactly will Terraform change?"

---

# Challenges Faced

```text
Challenges:

- Setting up the correct Folder Structure with modular design

- Mapping the files and folder

```

---

# Troubleshooting Notes


```text
Issue: 'tf' was alias not working 

Symptoms: command not found

Investigation: inspect the .bashrc file 

Root Cause: Read Only Template , 

Resolution: source ~/.bashrc 

Lessons Learned: when the alias of terminal work inappropriately , source .bashrc that reload the bash configurations
```

---

# Git Commits

```text
feat(terraform): configure AWS provider

feat(terraform): create Terraform environment

feat(terraform): create VPC configuration
```

---

# Sprint 2 Objective

Now we begin building the actual AWS network that will support EKS.

We are moving from this:

```text
VPC
```

To this:

```text
                    VPC
                     │
      ┌──────────────┴──────────────┐
      │                             │
Public Subnets                Private Subnets
      │                             │
      │                        EKS Worker Nodes
      │                             │
Internet Gateway               NAT Gateway
```

---

# What We'll Build in Sprint 2

## Networking

```text
VPC
│
├── Internet Gateway
│
├── Public Subnet (AZ-1)
│
├── Public Subnet (AZ-2)
│
├── Private Subnet (AZ-1)
│
├── Private Subnet (AZ-2)
│
├── Route Tables
│
└── NAT Gateway
```

---

# Why Are We Creating Public and Private Subnets?

## Public Subnets

Public subnets will eventually host resources such as:

```text
Internet Gateway
        │
        ▼
Public Subnet
        │
        ▼
Load Balancer
```

---

## Private Subnets

Private subnets will host:

```text
Private Subnet
        │
        ▼
EKS Worker Nodes
        │
        ▼
Application Pods
```

Worker nodes should not be directly exposed to the internet.

---

# CIDR Design

```text
VPC: 10.0.0.0/16

Public Subnet AZ-1:  10.0.1.0/24

Public Subnet AZ-2:  10.0.2.0/24

Private Subnet AZ-1: 10.0.11.0/24

Private Subnet AZ-2: 10.0.12.0/24
```

---

# AWS Concepts We'll Reinforce

* CIDR
* Subnets
* Public networking
* Private networking
* Route tables
* Internet Gateway
* NAT Gateway
* Availability Zones
* High availability
* EKS networking requirements

---

# Planned Failure Scenarios

We will intentionally break networking later.

Examples:

```text
Missing Internet Gateway

Incorrect Route Table

Wrong Subnet Association

NAT Failure

Node Internet Connectivity Failure
```

---

# Sprint 2 Success Criteria

```text
 Internet Gateway created

 Two public subnets created

 Two private subnets created

 Route tables configured

 NAT Gateway configured

 Subnets associated correctly

 Terraform apply completed

 Resources verified in AWS
```

---

# Next Implementation Tasks

1. Create two public subnets.

2. Create two private subnets.

3. Create an Internet Gateway.

4. Create a NAT Gateway.

5. Create route tables.

6. Associate the route tables with the correct subnets.

7. Apply the configuration.

8. Verify everything from both Terraform and the AWS Console.
