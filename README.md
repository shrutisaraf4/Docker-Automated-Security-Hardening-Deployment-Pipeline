# 🛡️ Docker Automated Security Hardening & Deployment Pipeline

![Docker Status](https://img.shields.io/badge/Docker-Orchestrated-blue?style=for-the-badge&logo=docker)
![Security Guard](https://img.shields.io/badge/Trivy-SecOps_Verified-brightgreen?style=for-the-badge&logo=securityscorecard)
![Bash Core](https://img.shields.io/badge/Pipeline-Automated-orange?style=for-the-badge&logo=gnubash)

An elite, production-grade DevOps infrastructure framework built completely within isolated container boundaries. This system leverages custom multi-stage build layers to render highly secure **Distroless** application footprints, forces automated strict compliance validation using **Trivy Vulnerability Scanners**, and applies fail-safe architectural rollbacks upon zero-day identification.

---

## 🎨 Project Visual Architecture

```text
┌─────────────────────────────────────────────────────────┐
│              💥 DEV APP WORKSPACE CODE                  │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│     🔨 MULTI-STAGE COMPILATION ENVELOPE (Dockerfile)     │
│  - Blocks Package Injection    - Discards Native Shells │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│      🔍 TRIVY THREAT INTELLIGENCE AUDITING INTERACTION  │
│  - Assesses Dependencies       - Flags CVE Exploits     │
└───────────────────────────┬─────────────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              │                           │
    [❌ CRITICAL THREATS]        [✅ VERIFIED CLEAN]
              │                           │
              ▼                           ▼
┌───────────────────────────┐┌────────────────────────────┐
│   🛑 FAIL-SAFE BLOCKER    ││ 🚀 DETACHED DEPLOYMENT     │
│  Tears Down Stale Stacks  ││ Live: http://localhost:3000│
└───────────────────────────┘└────────────────────────────┘
```

---

## 💎 Elite Engineering Features

*   **🔏 Attack Surface Elimination:** Uses multi-stage rules to strip container baselines down to pure compiled execution code—leaving zero host utility package managers (`apt`, `npm`) or operational terminals (`sh`, `bash`) for attackers to exploit.
*   **👥 Root Privilege Evacuation:** Enforces absolute standard drops, forcing the final production containers to execute purely inside the scoped sandbox space of `nonroot` identities.
*   **⛓️ Isolated Gateway Bridges:** Establishes isolated internal network topologies preventing unexpected external calls or configuration tampering.
*   **🔌 Master Command Wrapper:** Provides a single, clean automated interface removing the need to manage complex, multi-container flags manually.

---

## 📂 Structural Tree Overview

```text
Docker-Automated-Security-Pipeline/
├── app/
│   ├── package.json        # Service Manifest Properties
│   └── server.js           # Lightweight Isolated Web Host
├── Dockerfile              # Multi-Stage Secure Blueprint
├── docker-compose.yml      # Multi-Container Topology Orchestrator
├── Makefile                # Core Automation Directives Shortcut
├── pipeline.sh             # SecOps Automation Engine Brain
└── thumbnail.png           # Visual Component Asset
```

---

## 📷 Active System Demonstrations

### 🟢 1. Successful SecOps Execution
*Below shows the process running cleanly, passing the security audits, and spinning up the application safely.*

![Pipeline Success](screenshots/success.png)

### 🔴 2. Automated Deficit Interception (Fail-Safe Trap)
*Below shows the pipeline identifying critical package vulnerabilities, throwing a failure code, and tearing down the infrastructure safely.*

![Pipeline Failure](screenshots/failed.png)

---

## ⚡ Complete Implementation Walkthrough

### ⌨️ Step 1: Initialize Workspace Folders
Open your native terminal or system console shell engine and run the initialization commands:
```bash
mkdir Docker-Automated-Security-Pipeline
cd Docker-Automated-Security-Pipeline
mkdir app
```

### 🟩 Step 2: Establish Web Microservice Code (`app/server.js`)
Create the server script to handle your web service traffic inside the node runtime container environment:
```javascript
const http = require('http');
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('✅ Hardened Container App is Running Safely!\n');
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
```

### 🟩 Step 3: Define Dependency Properties (`app/package.json`)
```json
{
  "name": "docker-secure-app",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  }
}
```

### 🟩 Step 4: Construct the Hardened Blueprint (`Dockerfile`)
Write the multi-stage deployment rules. This cleanly splits compiler overhead steps away from the absolute raw final execution space:
```dockerfile
# ==========================================
# STAGE 1: COMPILATION ENGINE RUNTIME
# ==========================================
FROM node:20-alpine AS builder
WORKDIR /app
COPY app/package*.json ./
RUN npm ci
COPY app/ .

# ==========================================
# STAGE 2: IMMUTABLE DISTROLESS PRODUCTION
# ==========================================
FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app
COPY --from=builder /app /app
USER nonroot
EXPOSE 3000
CMD ["server.js"]
```

### 🟩 Step 5: Configure Service Topology (`docker-compose.yml`)
```yaml
version: '3.8'

services:
  web-app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    networks:
      - secure-network

  security-scanner:
    image: aquasec/trivy:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./scan-results:/root/.cache/
    entrypoint: [
      "trivy", "image", 
      "--severity", "CRITICAL", 
      "--exit-code", "1", 
      "docker-automated-security-pipeline-web-app:latest"
    ]
    depends_on:
      - web-app
    networks:
      - secure-network

networks:
  secure-network:
    driver: bridge
```

### 🟩 Step 6: Code the Engine Script (`pipeline.sh`)
This script checks execution codes dynamically. If security flaws are identified during scanning, it throws error gates to stop insecure builds:
```bash
#!/bin/bash
set -e

echo "⚡ Starting Automated Docker Security Pipeline..."

echo "📦 Step 1: Wiping obsolete workspace dependencies..."
docker compose down --remove-orphans

echo "🔨 Step 2: Compiling hardened structural multi-stage container target..."
docker compose build web-app

echo "🔍 Step 3: Launching automated dependency threat sweep..."
if docker compose run --rm security-scanner; then
    echo "✅ AUDIT VERDICT: 0 Critical Threats Detected. Provisioning Live Instance..."
    docker compose up -d web-app
    echo "🌐 Production endpoint active: http://localhost:3000"
else
    echo "❌ AUDIT VERDICT: Severe Threats Uncovered. Initiating Fail-Safe Shutdown!"
    docker compose down
    exit 1
fi
```

### 🟩 Step 7: Create Custom Terminal Bindings (`Makefile`)
```makefile
.PHONY: deploy clean

deploy:
	@chmod +x pipeline.sh
	@./pipeline.sh

clean:
	@docker compose down -v
	@echo "🧹 Workspace structures dropped cleanly."
```

---

## ⚡ Execution Operations

### 🚀 Production Run
To build infrastructure, audit assets, and spin up services with one command:
```bash
make deploy
```

### 🧹 Destructive Teardown
To turn off active elements, strip volumes, and clear cache states instantly:
```bash
make clean
```
