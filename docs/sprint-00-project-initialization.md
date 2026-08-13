# Sprint 0 — Project Initialization

**Status:**  In Progress
**Phase:** Project Foundation
**Sprint:** 0
**Primary Goal:** Establish the Git-based foundation, project structure, documentation strategy, and high-level architecture for the Kubernetes GitOps platform.

---

## 1. Sprint Objective

Establish the foundation of the project before provisioning any infrastructure.

This sprint focuses on:

* Creating the Git repository
* Defining the project structure
* Defining responsibilities of each technology
* Establishing the documentation strategy
* Defining the high-level architecture
* Defining how infrastructure and applications will flow through the system
* Establishing Git as the source of truth

No AWS infrastructure or Kubernetes resources are provisioned in this sprint.

---

## 2. Project Goal

Build a realistic Kubernetes-based DevOps platform on AWS using:

* AWS EKS
* Kubernetes
* Helm
* ArgoCD
* Terraform
* Ansible
* Git / GitHub

The project will not only demonstrate successful deployment.

We will intentionally introduce failures and troubleshoot them to simulate real operational scenarios.

The final project should demonstrate the complete lifecycle:

```text
Infrastructure Provisioning
        ↓
Configuration Management
        ↓
Kubernetes Deployment
        ↓
Application Packaging
        ↓
GitOps
        ↓
Monitoring / Verification
        ↓
Failure Injection
        ↓
Troubleshooting
        ↓
Recovery
        ↓
Documentation
```

---

## 3. Why This Project?

The purpose of this project is to convert previously studied concepts into practical operational knowledge.

Instead of learning each technology independently:

```text
Terraform
Kubernetes
Helm
Ansible
ArgoCD
Git
```

we will integrate them into a single workflow.

The project should answer practical questions such as:

* Why is Kubernetes required?
* Why use Helm instead of raw manifests?
* Why use ArgoCD?
* Where does Terraform stop and Kubernetes begin?
* Where does Ansible fit?
* What happens when Kubernetes configuration is wrong?
* How do we troubleshoot a failed deployment?
* How do we identify whether a problem is in AWS, Kubernetes, Helm, or the application?
* How does GitOps detect configuration drift?
* How does the system recover from failures?

---

# 4. Target Architecture

The target platform will look approximately like:

```text
                           GitHub
                              │
              ┌───────────────┴────────────────┐
              │                                │
              ▼                                ▼
         Terraform                         ArgoCD
              │                                │
              ▼                                │
          AWS Cloud                            │
              │                                │
        ┌─────┴──────┐                         │
        │            │                         │
       VPC           EKS ◄─────────────────────┘
        │             │
        │       ┌─────┴─────┐
        │       │           │
        │       ▼           ▼
        │    Kubernetes  Kubernetes
        │    Workloads   Services
        │                    │
        │                    ▼
        │                 Ingress
        │                    │
        │                    ▼
        │              AWS Load Balancer
        │
        └──────────────► RDS
```

Ansible will be used for configuration management of the supporting management/operations host.

---

# 5. Technology Responsibilities

## Terraform

Responsible for infrastructure provisioning.

Expected responsibilities:

```text
Terraform
├── VPC
├── Subnets
├── Route Tables
├── Internet Gateway
├── NAT Gateway
├── Security Groups
├── EKS Cluster
├── EKS Node Groups
├── IAM
├── RDS
└── Required AWS infrastructure
```

Terraform should be the source of truth for AWS infrastructure.

---

## Ansible

Responsible for configuration management.

Expected use:

```text
Management Host
      │
      ▼
   Ansible
      │
      ├── AWS CLI
      ├── kubectl
      ├── Helm
      ├── Git
      └── Troubleshooting utilities
```

The purpose is to demonstrate the distinction between:

```text
Terraform → Create infrastructure

Ansible → Configure machines
```

---

## Kubernetes

Responsible for application orchestration.

Expected resources include:

```text
Namespace
Deployment
ReplicaSet
Pod
Service
ConfigMap
Secret
Ingress
HPA
PDB
PVC
StorageClass
```

Additional scheduling and reliability features will be introduced where they make sense.

---

## Helm

Responsible for packaging Kubernetes applications.

The application will eventually move from raw Kubernetes manifests to a Helm chart.

Expected structure:

```text
helm/
└── application/
    ├── Chart.yaml
    ├── values.yaml
    ├── templates/
    └── ...
```

Helm will also allow us to experiment with:

* Different values
* Releases
* Upgrades
* Rollbacks
* Template rendering
* Configuration management

---

## ArgoCD

Responsible for GitOps-based application delivery.

The intended flow is:

```text
Git
 │
 ▼
ArgoCD
 │
 ▼
Helm
 │
 ▼
Kubernetes
```

Git will contain the desired state.

ArgoCD will continuously compare:

```text
Desired State
      vs
Live State
```

and reconcile the cluster where appropriate.

---

## Git / GitHub

Git is the source of truth for the project.

The repository will contain:

```text
Infrastructure
Configuration
Helm Charts
ArgoCD Configuration
Documentation
Troubleshooting Records
```

Every significant project milestone should be represented by a Git commit.

---

# 6. Repository Structure

The initial repository structure:

```text
eks-gitops-platform/
│
├── README.md
├── .gitignore
│
├── terraform/
│   ├── modules/
│   └── environments/
│       └── dev/
│
├── ansible/
│   ├── inventory/
│   ├── playbooks/
│   └── roles/
│
├── k8s/
│
├── helm/
│
├── argocd/
│
└── docs/
    ├── architecture.md
    ├── decisions.md
    ├── commands.md
    ├── troubleshooting.md
    ├── incidents.md
    └── sprints/
        └── sprint-00-project-initialization.md
```

The `sprints/` directory will contain a separate document for every sprint.

---

# 7. Sprint Documentation Strategy

Every sprint will have its own document.

The standard structure will be:

```text
Sprint N
│
├── Objective
├── Why
├── Scope
├── Plan
├── Implementation
├── Verification
├── Challenges
├── Troubleshooting
├── Final Outcome
├── Key Learnings
└── Git Commits
```

This allows the project to preserve not only the final result, but also the engineering process.

---

# 8. Troubleshooting Documentation Strategy

Failures are an intentional part of this project.

Whenever a problem occurs naturally or is intentionally introduced, we will document it.

Each significant incident should capture:

```text
Incident
│
├── What broke?
├── Symptoms
├── Initial hypothesis
├── Investigation
├── Commands used
├── Observations
├── Root cause
├── Fix
├── Verification
└── Prevention / Lesson
```

Example:

```text
Service has no endpoints

Symptoms:
Application is running but traffic is not reaching the Pods.

Investigation:
kubectl get svc
kubectl get endpoints
kubectl get endpointslices
kubectl describe svc

Root Cause:
Service selector did not match Pod labels.

Fix:
Corrected the selector.

Verification:
Endpoints appeared and application became reachable.

Lesson:
A Kubernetes Service routes traffic through its selected endpoints,
not directly through the Deployment.
```

---

# 9. Engineering Principles

Throughout the project we will follow these principles:

### 1. Understand before implementing

We should know why a component exists before adding it.

### 2. Infrastructure should be reproducible

AWS infrastructure should not depend on manual console configuration.

### 3. Git should represent desired state

Configuration should live in Git wherever practical.

### 4. Verify every change

After implementing something, verify that it actually works.

### 5. Break things intentionally

Important Kubernetes concepts should be reinforced by controlled failure scenarios.

### 6. Troubleshoot from evidence

We should avoid guessing.

The troubleshooting process should be:

```text
Symptom
  ↓
Observe
  ↓
Form hypothesis
  ↓
Run diagnostic
  ↓
Confirm / reject hypothesis
  ↓
Fix
  ↓
Verify
```

### 7. Document the journey

The final repository should explain not only **what we built**, but also **why we built it and what problems we encountered**.

---

# 10. Sprint 0 Implementation Checklist

* [ ] Create GitHub repository
* [ ] Clone repository locally
* [ ] Create project directory structure
* [ ] Create documentation directories
* [ ] Create initial README
* [ ] Create architecture document
* [ ] Create troubleshooting document
* [ ] Create incidents document
* [ ] Create sprint documentation directory
* [ ] Add `.gitignore`
* [ ] Commit initial project structure
* [ ] Push to GitHub

---

# 11. Expected Sprint 0 Outcome

At the end of this sprint we should have:

```text
GitHub Repository
       │
       ├── Terraform structure
       ├── Ansible structure
       ├── Kubernetes structure
       ├── Helm structure
       ├── ArgoCD structure
       └── Documentation structure
```

No AWS infrastructure should exist yet as a result of this sprint.

The project foundation should be ready for Sprint 1.

---

# 12. Sprint 0 Lessons

To be completed after implementation.

```text
What did we learn?

-

What design decisions did we make?

-

What problems did we encounter?

-

What would we change?

-
```

---

# 13. Git Commits

| Commit                                | Purpose                                    |
| ------------------------------------- | ------------------------------------------ |
| `chore: initialize project structure` | Initial repository and directory structure |
| `docs: add project architecture`      | Initial architecture documentation         |

Additional commits will be added as the sprint progresses.

---

# 14. Sprint Status

**Current Status:**  In Progress

**Next Sprint:**

> Sprint 1 — AWS Architecture & Terraform Infrastructure

The next sprint will design and provision the AWS foundation required for the EKS platform.
