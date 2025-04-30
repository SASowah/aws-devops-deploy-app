# AWS DevOps Deploy App Project

A fully automated, high-availability deployment of a Java web application using AWS EC2, Auto Scaling, S3, and IAM roles. Designed with scalability, fault tolerance, and cost optimization in mind.

---

## 📁 Project Structure

```bash
aws-java-deploy-project/
├── README.md
├── architecture-diagram.png
├── userdata-build.sh
├── userdata-deploy.sh
└── .gitignore

## 🔧 Architecture Overview

- **VPC** with public & private subnets across **2 Availability Zones**
- **Build Server** (Amazon Linux) in Public Subnet
  - Builds WAR using Maven, uploads to **S3**
- **Deploy Server** (Private Subnet)
  - Downloads WAR from S3, deploys to Tomcat
  - Managed via **Auto Scaling Group**
- **Application Load Balancer** routes HTTP traffic (port 80 → 8080)
- **CloudWatch Alarms** handle scaling events (CPU-based)
- **Custom Domain (Namecheap)** pointing to ALB DNS

---

## 📁 Files Included

userdata-build.sh	User data script for Build Server: compiles WAR, uploads to S3
userdata-deploy.sh	User data script for Deploy Server: downloads WAR, installs Tomcat
architecture-diagram.png	High-level architecture layout
.gitignore	Prevents pushing sensitive or unnecessary files

---

## 📦 S3 & IAM

- **S3 Bucket** stores WAR artifact and optional Tomcat .tar.gz
- **IAM Roles**:
  - `BuildServer-S3Uploader-Role`: Allows `s3:PutObject`
  - `DeployServer-S3Downloader-Role`: Allows `s3:GetObject`

---

## 📈 Auto Scaling Policies

- **Min:** 2 Instances | **Max:** 5
- **Scale Out:** If CPU ≥ 80%
- **Scale In:** If CPU ≤ 10%
- **CloudWatch Alarms** trigger scaling

---
##🧪 Failover & Testing

    Stress Test performed using stress --cpu 2 --timeout 300

    Verified Auto Scaling launches new instances on high load

    Load Balancer successfully routes traffic to new deploy instances

    Domain name resolves via Namecheap to ALB DNS
---

## 🔍 Common Debug Scenarios

| Issue | Cause | Fix |
|-------|-------|-----|
| ALB shows unhealthy | Tomcat not running or health path wrong | Correct user data, fixed `/javaweb3/` path |
| No internet in private subnet | Route/NAT misconfiguration | Updated route table to new NAT Gateway |
| ASG didn't scale | Target tracking conflict | Switched to alarm-based step scaling |

---

## ✅ Final Outcome

Live Java application deployed with full automation, scalability, fault tolerance, and custom domain routing — a production-ready DevOps AWS architecture.

---
📢 Credits

This project was completed as part of a DevOps learning journey, focused on real-world AWS automation and infrastructure deployment.
