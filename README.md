# 🚀 Cloud-to-Code: My Platform Engineering Sandbox

Welcome to my daily learning monorepo. I am a Cloud Engineer (GCP, Terraform, Advanced Ops) actively transitioning into modern **Platform Engineering and Software Development**. 

This repository serves as my daily scratchpad, proof-of-concept (PoC) storage, and muscle-memory gym for **Kubernetes, Python, Go, and Infrastructure as Code**.

## 📂 Repository Structure

Instead of creating 50 messy repositories, I track my daily progress here. The workspace is divided by technology and domain:

* **`/python-automation`** - Python scripts for API interactions, automation, and playing with the `kubernetes-client`.
* **`/k8s-manifests`** - My daily Kubernetes practice (Deployments, Services, ConfigMaps, and eventually Helm/Kustomize).
* **`/go-services`** - *[Coming Soon]* Small Go-based REST APIs and CLI tools to build my software engineering foundations.
* **`/terraform-gcp`** - Advanced Terraform modules, testing new GCP architectures, and GitOps workflows.

## 🛠️ My Local Development Environment

All container and Kubernetes experiments in this repository are designed to run on a lightweight, ephemeral local setup:
* **OS:** macOS
* **Container Engine:** [OrbStack](https://orbstack.dev/) (Drop-in, lightweight Docker Desktop replacement)
* **Local Cluster:** `k3d` (K3s in Docker)

**To spin up the exact cluster used for these projects:**
```bash
k3d cluster create dev-sandbox --servers 1 --agents 2