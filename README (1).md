# 🛡️ Docker Automated Security Hardening & Deployment Pipeline

![Docker Status](https://img.shields.io/badge/Docker-Orchestrated-blue?style=for-the-badge&logo=docker)
![Security Guard](https://img.shields.io/badge/Trivy-SecOps_Verified-brightgreen?style=for-the-badge&logo=securityscorecard)
![Bash Core](https://img.shields.io/badge/Pipeline-Automated-orange?style=for-the-badge&logo=gnubash)

This project is an **end-to-end, fully automated container DevSecOps pipeline**. It builds a minimized, ultra-secure multi-stage **Docker** image, subjects it to an aggressive vulnerability scan using **Trivy Threat Intelligence**, and safely handles live traffic or handles execution rollbacks depending on whether security flags are raised.

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
├── scan-results/
│   └── trivy-report.txt    # Generated Vulnerability Audit Logs
├── screenshots/
│   └── ...                 # Documentation Visual Evidence
├── Dockerfile              # Multi-Stage Secure Blueprint
├── docker-compose.yml      # Multi-Container Topology Orchestrator
├── Makefile                # Core Automation Directives Shortcut
└── pipeline.sh             # SecOps Automation Engine Brain
```

---

## 📖 Deep-Dive Explanations

### Where is this Used?
This architecture is deployed in **Production Environments** where applications are exposed to the public internet. It is highly valued in fields requiring strict compliance, such as Fintech, Healthcare, and SaaS Infrastructure, where shipping unverified containers or leaving shell access open poses severe security compliance risks.

### What Does the System Do?
1. It segregates development toolchains from the production runtime.
2. It strips out package managers (`npm`, `yarn`, `apt`) and system shells (`bash`, `sh`) to prevent post-exploitation code execution if a vulnerability is discovered.
3. It intercepts deployments mid-flight if dependencies carry **CVEs (Common Vulnerabilities and Exposures)**.

---

## 🐳 Line-by-Line Dockerfile Breakdown

Our Docker configuration acts as a multi-stage compilation envelope. Here is how it functions under the hood:

```dockerfile
# ==========================================
# STAGE 1: COMPILATION ENGINE RUNTIME
# ==========================================
FROM node:20-alpine AS builder
```
* **`FROM node:20-alpine AS builder`**: Sets a lightweight Alpine Linux image containing Node.js as our base environment. It tags this environment stage as `builder` so its compiled assets can be copied later.

```dockerfile
WORKDIR /app
```
* **`WORKDIR /app`**: Creates and sets the active context workspace to `/app` inside the container.

```dockerfile
COPY app/package*.json ./
```
* **`COPY app/package*.json ./`**: Pulls in package files to allow dependency setup isolation.

```dockerfile
RUN npm install --production
```
* **`RUN npm install --production`**: Runs clean dependency installation, dropping developer tools while installing only production-essential items.

```dockerfile
COPY app/ .
```
* **`COPY app/ .`**: Copies the rest of the application source code into our workspace.

```dockerfile
# ==========================================
# STAGE 2: IMMUTABLE DISTROLESS PRODUCTION
# ==========================================
FROM gcr.io/distroless/nodejs20-debian12
```
* **`FROM gcr.io/distroless/nodejs20-debian12`**: Discards the previous `builder` environment completely. It boots up an official Google Distroless Image. This image contains **only** the Node.js runtime—and contains absolutely no package managers, system shells (`sh`, `bash`), or standard Linux command utilities.

```dockerfile
WORKDIR /app
```
* **`WORKDIR /app`**: Sets the deployment runtime path context.

```dockerfile
COPY --from=builder /app /app
```
* **`COPY --from=builder /app /app`**: Pulls over *only* the clean application source code and its production modules directly from our `builder` stage, keeping all build tools behind.

```dockerfile
USER nonroot
```
* **`USER nonroot`**: Evacuates administrative privileges, changing execution context to a low-privilege system account named `nonroot`.

```dockerfile
EXPOSE 3000
```
* **`EXPOSE 3000`**: Documents our container network mapping configuration.

```dockerfile
CMD ["server.js"]
```
* **`CMD ["server.js"]`**: Instructs the container to run our script directly. Because there is no underlying shell interpretation utility inside a Distroless environment, the standard `node` prefix is skipped.

---

## ⚡ Step-by-Step Implementation Walkthrough

Follow these instructions to spin up the workspace environment using GitHub Codespaces:

### Step 1: Create Your Codespace Environment
1. Log into your GitHub Profile.
2. Create a new public or private repository named `Docker-Automated-Security-Hardening`.
3. Click on the **Code** dropdown button, navigate to the **Codespaces** tab, and select **Create codespace on main**.
<img width="954" height="298" alt="image" src="https://github.com/user-attachments/assets/5dc27cd1-7c9d-414b-8ee5-1ac5df70a1a0" />
<img width="957" height="397" alt="image" src="https://github.com/user-attachments/assets/e745eb69-93fb-497c-ab88-b3636e55dcbf" />

### Step 2: Establish the Code Tree Structure
When your workspace terminal opens, verify your tools and configure the working directory framework:
<img width="934" height="379" alt="image" src="https://github.com/user-attachments/assets/e33ae2f5-239d-467a-95cc-ae7f6841ea39" />

```bash
# Check underlying operational components
docker --version
docker compose version

# Generate required directories
mkdir app
mkdir scan-results
mkdir screenshots
```
<img width="1017" height="131" alt="Screenshot 2026-09-07 193808" src="https://github.com/user-attachments/assets/c33579bb-e576-4512-98d3-eb483a96f13f" />

### Step 3: Populate Workspace Configuration Files
Create the primary components using your console text tool or by piping data into target manifests:
<img width="1087" height="501" alt="Screenshot 2026-09-07 194019" src="https://github.com/user-attachments/assets/72febaf3-443a-416d-b3c8-309142c2949b" />

#### `app/server.js`
```javascript
const http = require('http');
const port = 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('✅ Hardened Container App is Running Safely!\n');
});

server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
```

#### `app/package.json`
<img width="959" height="299" alt="Screenshot 2026-09-07 194206" src="https://github.com/user-attachments/assets/61e4dfc2-ae40-4bc9-941b-e66951cbf1c6" />

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

#### `Dockerfile`
<img width="1006" height="565" alt="Screenshot 2026-09-07 194401" src="https://github.com/user-attachments/assets/8cabb30e-c9dc-4596-bea6-ac9165134ab5" />

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY app/package*.json ./
RUN npm install --production
COPY app/ .

FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app
COPY --from=builder /app /app
USER nonroot
EXPOSE 3000
CMD ["server.js"]
```

#### `pipeline.sh`
<img width="1917" height="778" alt="Screenshot 2026-09-07 224413" src="https://github.com/user-attachments/assets/f8537684-7680-4428-9a62-8a710fd037c4" />

```bash
#!/bin/bash
set -e

echo "Building image..."
docker build -t secure-app .

echo "Running Trivy scan..."
docker run --rm   -v /var/run/docker.sock:/var/run/docker.sock   aquasec/trivy:latest image   --severity CRITICAL   --exit-code 1   secure-app

echo "No critical vulnerabilities found."
echo "Deploying application..."
docker run -d -p 3000:3000 secure-app
```

Make your script engine file operational:
<img width="1362" height="54" alt="Screenshot 2026-09-07 224527" src="https://github.com/user-attachments/assets/33b23d06-0762-4878-9190-37988314d218" />

```bash
chmod +x pipeline.sh
```

---

## 📷 Active System Demonstrations

### 🟢 1. Successful SecOps Pipeline Execution
Run the system setup using your manual step overrides or by kicking off your orchestration loops. The pipeline validates configuration components, ensures zero issues exist, and boots the microservice cleanly.
<img width="1059" height="709" alt="Screenshot 2026-09-07 221651" src="https://github.com/user-attachments/assets/46c90348-fa23-4f87-89c2-a3ff221d6246" />
<img width="940" height="88" alt="Screenshot 2026-09-07 222122" src="https://github.com/user-attachments/assets/bc571c94-22b9-4f2b-82d4-296b61bf6a6c" />

```bash
docker build -t secure-app .
docker run -d -p 3000:3000 secure-app
```

#### Verifying Active Infrastructure Endpoints
Test responses locally inside your codespace console:
<img width="918" height="85" alt="Screenshot 2026-09-07 222309" src="https://github.com/user-attachments/assets/290a5a8c-70f4-4019-a94b-a9d1c05eb467" />

```bash
curl localhost:3000
```
Alternatively, access the built-in workspace port mapping interface directly through your browser:
![Browser Port Forwarding Verification](https://raw.githubusercontent.com/shrutisaraf4/Docker-Automated-Security-Hardening-Deployment-Pipeline/main/screenshots/ports_forward.png)

***

### 🔴 2. Automated Deficit Interception (Fail-Safe Trap)
When Trivy Threat Intelligence flags a vulnerability, the automated security gate halts operations instantly. 

For example, when auditing an image version that contains an unpatched vulnerability—such as **CVE-2026-31789** inside `libssl3`—the vulnerability scanner exits with a non-zero failure flag (`exit-code 1`). This halts the automated deployment script before insecure code can reach production.

Execute a targeted vulnerability scan to view this constraint in action:
<img width="1381" height="621" alt="Screenshot 2026-09-07 224111" src="https://github.com/user-attachments/assets/dbbef044-4b05-4b34-b060-ed687bb2fa5e" />

```bash
docker run --rm   -v /var/run/docker.sock:/var/run/docker.sock   aquasec/trivy:latest image   --severity CRITICAL   --format table   secure-app
```

#### Exporting Security Audit Analytics
To store these logs for historical reference, pipe your data payload into a text report artifact:
<img width="1845" height="761" alt="Screenshot 2026-09-07 231535" src="https://github.com/user-attachments/assets/96bc6be6-e382-4583-8449-d2c3380f9f61" />

```bash
docker run --rm   -v /var/run/docker.sock:/var/run/docker.sock   aquasec/trivy:latest image   --severity CRITICAL   secure-app > scan-results/trivy-report.txt
```
#### Committing Assets to Version Control
Save your workspace progress and commit the generated report to your repository:
<img width="1849" height="779" alt="Screenshot 2026-09-07 232042" src="https://github.com/user-attachments/assets/ea7b4b7b-9d00-4162-b91b-d3e09e3b5616" />

```bash
git add .
git commit -m "Add Trivy security report"
git push origin main
```
![Git Compliance Push](https://raw.githubusercontent.com/shrutisaraf4/Docker-Automated-Security-Hardening-Deployment-Pipeline/main/screenshots/git_commit.png)

***

## 🧼 System Cleanup Operations
To completely turn off active containers, wipe out dangling volumes, and reset your workspace cache, run the following cleanup command:
<img width="697" height="123" alt="image" src="https://github.com/user-attachments/assets/df0f1c81-154f-402c-b1fa-2c76affb50d6" />

```bash
docker rm -f $(docker ps -aq) 2>/dev/null || true
echo "Subscribed workspace structures dropped cleanly."
```
