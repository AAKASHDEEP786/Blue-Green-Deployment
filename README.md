Blue-Green Deployment on AWS with Jenkins, SonarQube, and Nexus

This project demonstrates how to set up a CI/CD pipeline with Blue-Green Deployment using AWS EKS, Jenkins, SonarQube, Nexus, and Terraform.

The goal is to automate infrastructure provisioning, application deployment, and quality/security checks while enabling zero-downtime deployments using the Blue-Green strategy.

🚀 Features

Provision AWS infrastructure with Terraform

Deploy and manage EKS (Elastic Kubernetes Service) cluster

Configure Jenkins CI/CD pipeline with Docker, Maven, Trivy, and Kubernetes

Integrate SonarQube for static code analysis

Use Nexus Repository as an artifact store

Perform Blue-Green Deployment on Kubernetes with traffic switching

🏗️ Project Architecture
+-------------------+         +-----------------+         +------------------+
|   Developer Code  |  --->   |     Jenkins     |  --->   |    Kubernetes    |
|   (GitHub Repo)   |         | (Build & Deploy)|         |  (Blue/Green Env)|
+-------------------+         +-----------------+         +------------------+
        |                             |                            |
        |   SonarQube (Code Quality)  |   Nexus (Artifacts)        |
        +-----------------------------+----------------------------+

📌 Prerequisites

AWS Account with IAM user credentials

Terraform installed

AWS CLI installed & configured (aws configure)

Kubectl installed

EC2 instances for Jenkins, Nexus, and SonarQube (t2.medium or higher)

GitHub repository for application source code

⚙️ Step 1 — Provision Infrastructure

Provision EC2 instances and security groups using Terraform.
Allowed ports: 22, 80, 443, 8080, 8081, 9000.

git clone https://github.com/AAKASHDEEP786/Blue-Green-Deployment.git
cd Blue-Green-Deployment/Cluster
terraform init
terraform plan
terraform apply --auto-approve

⚙️ Step 2 — Setup EKS Cluster
aws eks update-kubeconfig --region <region> --name <cluster-name>
kubectl get nodes
kubectl get pods --all-namespaces

⚙️ Step 3 — RBAC for Jenkins

Create namespace, service account, role, and role binding.

kubectl create ns webapps
kubectl apply -f sa.yaml
kubectl apply -f role.yaml
kubectl apply -f rolebinding.yaml
kubectl apply -f secret.yaml -n webapps
kubectl describe secret mysecretname -n webapps

⚙️ Step 4 — Setup Jenkins Server

Install Jenkins and Docker:

sudo apt install openjdk-17-jre-headless -y
sudo apt-get install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins


Access Jenkins:
👉 http://<public-ip>:8080

Install Docker & Trivy for container build and scanning.

⚙️ Step 5 — Setup Nexus Repository

Run Nexus in Docker:

docker run -d --name nexus -p 8081:8081 sonatype/nexus3


Access Nexus:
👉 http://<public-ip>:8081

Default credentials: admin / <password from /nexus-data/admin.password>

⚙️ Step 6 — Setup SonarQube

Run SonarQube in Docker:

docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community


Access SonarQube:
👉 http://<public-ip>:9000
Default credentials: admin / admin

Create a token for Jenkins and add a webhook.

⚙️ Step 7 — Jenkins Configuration

Install required plugins:

SonarQube Scanner

Config File Provider

Maven & Pipeline plugins

Docker Pipeline

Kubernetes CLI & Credentials

Configure:

SonarQube server

Nexus credentials

DockerHub credentials

GitHub credentials

⚙️ Step 8 — Blue-Green Deployment Job

Jenkins pipeline parameters:

DEPLOY_ENV → blue or green (environment)

DOCKER_TAG → blue or green (image tag)

SWITCH_TRAFFIC → true/false (switch service to new env)

This ensures zero-downtime deployment by running new versions in parallel and switching traffic once validated.

✅ Verification

Jenkins Pipeline success

Application deployed to Kubernetes (kubectl get svc,pods -n webapps)

Blue/Green traffic switch using Kubernetes Service selector
