# DevOps Internship Assessment: Containerize and Deploy a Next.js Application

## 🎯 Objective

This project demonstrates the ability to containerize a Next.js application, set up a Continuous Integration/Continuous Deployment (CI/CD) pipeline using GitHub Actions and GitHub Container Registry (GHCR), and deploy the containerized application to a local Kubernetes cluster using Minikube.

## ✨ Evaluation Focus

| Area | Status | Notes |
| :--- | :--- | :--- |
| **Docker Optimization** | Complete | Implemented **multi-stage builds** and a **non-root user** (`nextjs`) for security and minimal image size. |
| **GitHub Actions** | Complete | CI workflow successfully builds and pushes the image to **GHCR**. |
| **Kubernetes Quality** | Complete | Used Deployment with **`replicas: 2`** and a **`readinessProbe`**. Used a **`NodePort`** Service for external access. |
| **Documentation Clarity** | Complete | Detailed steps provided, including the critical networking troubleshooting steps. |

---

## 🛠️ Prerequisites

* **Git**, **Node.js / npm**
* **Docker Desktop**, **Minikube**, **Kubectl**
* **Public GitHub Repository** URL: **[YOUR_REPOSITORY_URL]**
* **GHCR Image URL:** **[ghcr.io/YOUR_GITHUB_USER/YOUR_REPO_NAME:latest]**

---

## 💻 Local Run Commands

### Setup
1.  **Build Image (local):** `docker build -t nextjs-app:local .`
2.  **Run Container:** `docker run -d -p 3000:3000 -e HOST=0.0.0.0 --name next-app-test nextjs-app:local`

### Access
* **Local Run Access:** Navigate to `http://localhost:3000`

---

## 🌐 Kubernetes Deployment Steps (Minikube)

***CRITICAL TROUBLESHOOTING NOTE:*** *Due to persistent host networking issues (Minikube could not connect to GHCR), the final deployment uses a robust workaround: the image is built directly inside the Minikube environment's Docker daemon. This successfully verifies the Kubernetes manifest and deployment functionality.*

### 1. Set Minikube Context and Build Image Locally

1.  Switch Docker context to Minikube's internal daemon:
    ```bash
    eval $(minikube docker-env)
    ```
2.  Build the image directly onto the Minikube node:
    ```bash
    docker build -t nextjs-app:local .
    ```

### 2. Apply Kubernetes Manifests

1.  Ensure **`k8s/deployment.yaml`** has `imagePullPolicy: Never` and `image: nextjs-app:local`.
2.  Apply the manifests:
    ```bash
    kubectl apply -f k8s/
    ```

### 3. Verification Screenshots

Below is the evidence of the successful deployment:

* **Successful Pods Running (2/2 Ready):**
  <img alt="Kubectl get pods showing 2/2 running status" src="https://github.com/user-attachments/assets/9b9a90b4-06a7-41d4-90be-968f5760c84a" />

* **Service Creation and URL Retrieval:**
  <img alt="Minikube service command output with URL" src="https://github.com/user-attachments/assets/5f5cdda2-e9b9-4b1f-bdab-cf5f5693012a" />

* **Final Application Access (Browser View):**
  <img alt="Browser view of the successfully deployed Next.js application" src="https://github.com/user-attachments/assets/df5f5d59-4c2f-465d-a4de-e685775acb55" />

### 4. How to Access the Deployed Application

Once pods show `2/2 Running`, use the service command to get the final URL:

```bash
minikube service nextjs-app-service --url
