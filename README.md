# 🤖 AI-Powered English Grammar Corrector & Syntax Parser

![Python](https://img.shields.io/badge/Python-3.9-blue?logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Framework-Flask-green?logo=flask&logoColor=white)
![AWS](https://img.shields.io/badge/Cloud-AWS-orange?logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/Container-Docker-blue?logo=docker&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)

## 💡 Project Overview

**English Grammar Corrector** is a real-time web application (API) leveraging the **T5 Transformer model** to perform syntax parsing and grammar correction. The project demonstrates a complete **DevOps lifecycle**, from containerization with Docker to automated deployment on AWS Cloud using CI/CD pipelines.

| Project Info | Details |
|:--- |:--- |
| **Live Demo** | `http://47.129.209.29/` *(Note: Dynamic IP, subject to change)* |
| **Core Model** | T5 Transformer (`grammarly/coedit-large`) |
| **Backend Stack** | Python 3.9, Flask, PyTorch, Hugging Face Transformers |
| **Build Status** | ![Build Status](https://img.shields.io/badge/build-passing-brightgreen) |

---

## 📸 Product Screenshots

### 1. Core Workflow (Quy trình chính)
Trải nghiệm người dùng mượt mà từ việc nhập liệu đến nhận kết quả phân tích AI.

| **Smart Editor Interface** | **AI Error Detection** |
|:---:|:---:|
| ![Home](docs/images/homepage.png) | ![Analysis](docs/images/enter_incorrectly.png) |
| *Giao diện soạn thảo sạch sẽ, tập trung* | *Phát hiện lỗi ngữ pháp & Phân tích cú pháp thời gian thực* |

### 2. Advanced Features (Tính năng nâng cao)
Hỗ trợ đa phương thức nhập liệu và gợi ý thông minh.

| **AI Suggestions** | **Voice Input Support** |
|:---:|:---:|
| ![Suggestions](docs/images/ai_suggestions.png) | ![Voice](docs/images/voice_input.png) |
| *Gợi ý chỉnh sửa văn phong tự nhiên* | *Tích hợp nhận diện giọng nói (Speech-to-Text)* |

### 3. User Management
Hệ thống quản lý người dùng bảo mật.

| **Secure Login** | **Registration** |
|:---:|:---:|
| ![Login](docs/images/login.png) | ![Register](docs/images/register.png) |
| *Đăng nhập bảo mật với Session Management* | *Đăng ký tài khoản người dùng mới* |

---

## ⚙️ Technical Architecture & Stack

| Category | Tools & Technologies |
|:--- |:--- |
| **Cloud Infrastructure** | **AWS EC2** (t2.micro/t3.micro), **EBS** (Volume Management), **Amazon Linux 2023** |
| **Containerization** | **Docker** (Multi-stage build), **Docker Volumes** (Model Caching) |
| **DevOps & CI/CD** | **GitHub Actions** (Automated Build & Push to Docker Hub), **Nginx** (Reverse Proxy) |
| **Networking & OS** | Security Groups, SSH Tunneling, Linux Administration (Systemctl, Bash Scripting) |

---

## 🧠 Technical Highlights & Problem Solving

This project showcases practical solutions to real-world infrastructure challenges on limited resources (AWS Free Tier):

### 1. Resource Optimization (OOM Killer Mitigation)
- **Challenge:** The `t3.micro` instance (1GB RAM) consistently crashed when loading the 3.13GB T5 Model due to Out-Of-Memory (OOM) errors.
- **Solution:** Implemented a **4GB Swap File** on the Linux filesystem to extend virtual memory, allowing the heavy AI model to run smoothly on a low-cost instance.

### 2. Zero-Downtime Storage Scaling
- **Challenge:** Encountered `no space left on device` error during Docker image pulling (Image size > 8GB).
- **Solution:** Performed **Live EBS Volume Resizing** (8GB → 30GB) and expanded the XFS filesystem (`xfs_growfs`) without stopping the instance.

### 3. Model Caching Strategy
- **Solution:** Utilized **Docker Volumes** to map the Hugging Face cache from the host to the container (`-v /hf_cache:/root/.cache`). This eliminates the need to re-download the 3GB model on every container restart, significantly reducing startup time and bandwidth usage.

### 4. Reverse Proxy Tuning
- **Solution:** Configured **Nginx** as a reverse proxy with extended `proxy_read_timeout` (300s) to handle long-running AI inference requests, preventing 504 Gateway Timeouts.

---

## 🚀 Deployment Guide

The deployment process is fully automated via CI/CD for the build phase, with streamlined operations for the deploy phase.

### 1. Infrastructure Setup (AWS)
1. Launch **EC2 Instance** (Amazon Linux 2023, t3.micro).
2. Configure **Security Groups** to allow SSH (22) and HTTP (80).
3. Provision **30GB EBS Root Volume** to accommodate Docker images and AI models.
4. Set up **Swap Memory** manually via SSH.

### 2. CI/CD Pipeline (GitHub Actions)
Any push to the `master` branch triggers the pipeline:
- **Build:** Creates a Docker image from the source code.
- **Push:** Uploads the image to Docker Hub (`hqkietsoft/english-syntax-parser`).

### 3. Server Update Command
SSH into the EC2 instance and run the following command to deploy the latest version:

```bash
# 1. Pull the latest image
sudo docker pull hqkietsoft/english-syntax-parser:latest

# 2. Remove old container and start the new one (with Volume Mapping)
sudo docker rm -f nlp-app
sudo docker run -d \
  --restart=always \
  -p 5000:5000 \
  -v /home/ec2-user/hf_cache:/root/.cache/huggingface \
  --name nlp-app \
  hqkietsoft/english-syntax-parser:latest
