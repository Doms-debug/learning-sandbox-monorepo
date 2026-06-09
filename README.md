# Platform Engineering Sandbox
### Key Components:
- **Frontend:** A responsive, premium dark-themed portfolio website built with HTML5, CSS3 (Grid & Flexbox), and vanilla JavaScript, hosted statically on **Google Cloud Storage (GCS)**.
- **Backend:** A serverless **Python** API hosted on **Cloud Run / Cloud Functions** that handles visitor counting logic.
- **Database:** **Google Cloud Firestore** (NoSQL) operating in Native Mode, used to persist and update the real-time visitor counter.
- **Infrastructure as Code (IaC):** The entire cloud environment is declaratively defined and provisioned using **Terraform**, ensuring absolute reproducibility.
- **CI/CD Pipeline:** Fully automated deployments via **GitHub Actions**. Code changes to the frontend or infrastructure trigger automatic updates to GCP resources.

---

## 💸 FinOps & Cost Optimization (Architectural Trade-Off)

Originally, this architecture utilized a **GCP Global HTTP(S) Load Balancer** with an asymmetric routing configuration (URL Map splitting traffic between a Backend Bucket for frontend and a Serverless NEG for backend under a single IP). 

While production-ready, a Global Forwarding Rule incurs a baseline idle cost (~$18/month). Adhering to **FinOps best practices for sandbox environments**, the architecture was intentionally refactored to achieve **100% Free-Tier eligibility**:
1. Removed the Global Load Balancer to eliminate fixed hourly forwarding fees.
2. Exposed the GCS static bucket directly for public frontend hosting.
3. Enabled CORS handling on the Python backend to securely allow Cross-Origin requests from GCS to the `.run.app` endpoint.
4. **Result:** Operational costs dropped from ~50 PLN/month to **0 PLN/month**, while fully preserving functionality, automation, and security posture.

---

## 🛡️ Security & Best Practices

- **Keyless Authentication:** The CI/CD pipeline connects to Google Cloud using **Workload Identity Federation (OIDC)**. No long-lived service account JSON keys are stored in GitHub Secrets, eliminating the risk of credential leakage.
- **Least Privilege Principle:** The GitHub Actions service account is strictly bound only to the required IAM roles (`roles/storage.objectAdmin`, `roles/run.admin`, etc.).
- **Environment Separation:** Infrastructure state is managed remotely using a secure cloud backend configuration for Terraform.

---

## 🛠️ Tech Stack & Skills Demonstrated

- **Cloud Provider:** Google Cloud Platform (GCP)
- **Infrastructure as Code:** Terraform
- **CI/CD:** GitHub Actions, Workload Identity Federation
- **Backend Development:** Python, Functions Framework
- **Database:** Cloud Firestore (NoSQL)
- **Frontend Development:** HTML5, CSS3 (Glassmorphic UI, CSS Variables), JavaScript (Async/Fetch API)

---

## 📖 How to Deploy Locally

### Prerequisites
- GCP Account and a project created.
- Google Cloud CLI (`gcloud`) installed and authenticated.
- Terraform CLI installed.

### Steps
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/gcp-cloud-resume.git](https://github.com/your-username/gcp-cloud-resume.git)
   cd gcp-cloud-resume
