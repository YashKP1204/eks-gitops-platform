# Sprint 2 - VPC Networking and Infrastructure Drift

**Sprint Goal**

Design and provision a production-style AWS networking layer for an EKS cluster using a modular Terraform architecture.

---

# Objectives

- Refactor the Terraform code into reusable modules.
- Create a dedicated VPC module.
- Build a multi-AZ network architecture.
- Create public and private subnets.
- Configure internet access.
- Configure outbound access for private resources.
- Implement route tables and route associations.
- Simulate a real-world infrastructure drift scenario.
- Troubleshoot and recover the infrastructure.

---

# Architecture

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
┌─────────────────────────────┐
│            VPC              │
│         10.0.0.0/16         │
└─────────────────────────────┘
              │
      ┌───────┴───────┐
      │               │
      ▼               ▼

Public Subnet A   Public Subnet B
10.0.1.0/24       10.0.2.0/24
AZ-1              AZ-2
      │
      ▼
NAT Gateway
      │
      ▼

Private Subnet A  Private Subnet B
10.0.11.0/24      10.0.12.0/24
AZ-1              AZ-2
      │
      ▼
Future EKS Worker Nodes
```

---

# Implementation

## Refactoring

Converted the Terraform code into a modular architecture.

**Directory Structure**

```text
terraform/
│
├── modules/
│   │
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── environments/
    │
    └── dev/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── providers.tf
```

---

## Resources Created

### VPC

```text
CIDR: 10.0.0.0/16
```

---

### Public Subnets

```text
Public Subnet A
CIDR: 10.0.1.0/24

Public Subnet B
CIDR: 10.0.2.0/24
```

---

### Private Subnets

```text
Private Subnet A
CIDR: 10.0.11.0/24

Private Subnet B
CIDR: 10.0.12.0/24
```

---

### Internet Gateway

```text
Attached to the VPC
```

---

### NAT Gateway

```text
Elastic IP attached

Deployed inside a public subnet
```

---

### Route Tables

**Public Route Table**

```text
0.0.0.0/0 → Internet Gateway
```

**Private Route Table**

```text
0.0.0.0/0 → NAT Gateway
```

---

# Important Concepts Learned

## A subnet does not become public simply because:

```hcl
map_public_ip_on_launch = true
```

A subnet becomes public only when all three conditions are satisfied:

```text
Public IP

+

Route Table

+

Internet Gateway
```

---

## Why are worker nodes deployed inside private subnets?

- Better security
- Reduced attack surface
- No direct exposure to the internet

---

## Why is the NAT Gateway deployed inside a public subnet?

The NAT Gateway must be able to communicate with the Internet Gateway.

Traffic flow:

```text
Private Subnet

↓

NAT Gateway

↓

Internet Gateway

↓

Internet
```

---

# Troubleshooting Scenario

## Infrastructure Drift

### Action Performed

The NAT Gateway was manually deleted from the AWS Console.

---

### Symptoms

```text
NAT Gateway → Deleted

Route Table → Blackhole Route
```

---

### Investigation

Executed:

```bash
terraform plan
```

Terraform detected that the actual infrastructure no longer matched the Terraform state.

---

### Root Cause

```text
Terraform State

↓

NAT Gateway exists

↓

AWS Infrastructure

↓

NAT Gateway deleted
```

---

### Impact

The private subnets lost outbound internet connectivity.

The following operations failed:

```text
Pull container images

Download package updates

Reach external APIs

Access public endpoints
```

---

### Resolution

Executed:

```bash
terraform apply
```

Terraform recreated the missing NAT Gateway and restored the infrastructure.

---

# Lessons Learned

- Never modify Terraform-managed resources manually.
- Terraform state is the source of truth.
- A Blackhole route usually indicates a missing network target.
- NAT Gateways are essential for outbound traffic from private subnets.
- Infrastructure drift is a common production issue.

---

# Sprint Outcome

- Modular Terraform architecture implemented.
- Production-style networking configured.
- Infrastructure drift intentionally introduced.
- Troubleshooting completed successfully.

---

# Git Commit

```bash
git add .

git commit -m "feat(terraform): implement modular VPC networking and troubleshoot infrastructure drift"
```