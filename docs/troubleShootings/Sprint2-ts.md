# Sprint 2 - Troubleshooting Scenario 1

## Scenario

The NAT Gateway was **manually deleted from the AWS Console**.

---

## Initial Architecture

```text id="r4v2xn"
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Public Subnet
    │
    ▼
NAT Gateway
    │
    ▼
Private Route Table
    │
    ▼
Private Subnets
```

---

## Manual Change

```text id="tvlx4h"
AWS Console

↓

Delete NAT Gateway
```

---

## Symptoms

### AWS Console

```text id="qk0nk5"
NAT Gateway → Deleted
```

### Route Table

```text id="7zc3z4"
0.0.0.0/0 → Blackhole
```

---

## Investigation

### Step 1

Inspect the private route table.

Result:

```text id="2oq4hu"
Blackhole route detected.
```

---

### Step 2

Run:

```bash id="1n9q34"
terraform plan
```

---

## Terraform Output

Terraform detected that the infrastructure no longer matched the Terraform state.

Terraform proposed:

```text id="2f4kuq"
Create a new NAT Gateway.

Update the private route table.

Replace the missing NAT Gateway ID.
```

---

## Root Cause

```text id="rdg25m"
Terraform state → NAT Gateway exists.

AWS infrastructure → NAT Gateway deleted.
```

The infrastructure and the Terraform state became inconsistent.

---

## This Problem Is Called Infrastructure Drift

```text id="8yjlwm"
Terraform State
        │
        ▼
Expected Infrastructure
        │
        ▼
AWS Infrastructure
```

A manual change caused the actual infrastructure to drift away from the desired infrastructure.

---

## Impact

Without the NAT Gateway:

```text id="qay7yj"
Private Subnets
        │
        ▼
Outbound Internet Access ❌
```

---

## What Stops Working?

```text id="bfyvwn"
Pull container images ❌

Install OS updates ❌

Download Helm charts ❌

Access external APIs ❌

Reach public endpoints ❌
```

---

## Resolution

```bash id="rsl1ab"
terraform apply
```

Terraform recreated the missing resource and restored the infrastructure.

---

## Lessons Learned

* Avoid manual changes to Terraform-managed resources.
* Terraform can detect infrastructure drift.
* A Blackhole route usually indicates a missing network target.
* NAT Gateways are critical for private subnet connectivity.
* The Terraform state file should always remain the source of truth.
