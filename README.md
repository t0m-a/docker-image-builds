# CONTAINERIZED SECURITY & INFRASTRUCTURE BUILDS // DOCKER ARCHIVE

> **Deterministic Container Engineering · Ephemeral Security Environments · 10,000+ Community Pulls on Docker Hub**

[![Docker Hub Pulls](https://img.shields.io/badge/DOCKER_HUB-10k%2B_PULLS-0A0A0A?style=flat-square&logo=docker&logoColor=2496ED)](https://hub.docker.com/r/simonthomas/armitage)
[![Docker Image](https://img.shields.io/badge/IMAGE-simonthomas%2Farmitage-0A0A0A?style=flat-square&logo=kalilinux&logoColor=557C94)](https://hub.docker.com/r/simonthomas/armitage)
[![Orchestration](https://img.shields.io/badge/ORCHESTRATION-Docker_Compose_%7C_X11_IPC-0A0A0A?style=flat-square&logo=linux&logoColor=FCC624)](https://github.com/t0m-a/docker-image-builds)
[![Architect](https://img.shields.io/badge/ARCHITECT-tsimon.me-0A0A0A?style=flat-square&logo=cloudflare&logoColor=F38020)](https://tsimon.me)
[![Status](https://img.shields.io/badge/STATUS-PRODUCTION_ARCHIVE-0A0A0A?style=flat-square&logo=git&logoColor=F05032)](https://github.com/t0m-a)

---

### `[01 // ARCHITECTURAL OVERVIEW & REPOSITORY SCOPE]`

This repository houses custom `Dockerfile` specifications, multi-container `docker-compose` topologies, and build automation scripts engineered to isolate complex security auditing tools and infrastructure services inside reproducible Linux containers.

Originally architected to eliminate host-level dependency pollution during penetration testing and network operations, the flagship build in this collection—**[`simonthomas/armitage`](https://hub.docker.com/r/simonthomas/armitage)**—has surpassed **10,000+ pulls on Docker Hub**, providing an ephemeral, X11-forwarded Metasploit & Armitage red-team workspace backed by containerized PostgreSQL telemetry.

> **[OPERATOR NOTE // EVOLUTION TO EDGE & ZERO-TRUST]:** Retained as a foundational containerization archive (2018–2019). For current ARM64 Edge Compute, Cloudflare Zero-Trust Tunnels, and Local AI/RAG container architectures, inspect:
> * **[`raspberry-pi-cloudflare-network-operations-monitor`](https://github.com/t0m-a/raspberry-pi-cloudflare-network-operations-monitor)** *(Live at [`pi.tsimon.me`](https://pi.tsimon.me))*
> * **[`Edge-Semantic-Search-RAG-Knowledge-Hub`](https://github.com/t0m-a/Edge-Semantic-Search-RAG-Knowledge-Hub)** *(Live at [`search.tsimon.me`](https://search.tsimon.me))*
> * **[`scout-analyst-pipelines-agents`](https://github.com/t0m-a/scout-analyst-pipelines-agents)** *(Multi-Agent Python Reconnaissance Pipelines)*

---

### `[02 // CONTAINER TOPOLOGY & X11 / IPC ARCHITECTURE]`

Rather than running heavy VMs or polluting the host OS with conflicting Ruby, Java, and database packages, this architecture decouples the **PostgreSQL state layer**, the **Metasploit RPC daemon (`msfrpcd`)**, and the **Java Swing GUI (`Armitage`)**, bridging visual output directly to the host display server over an isolated Unix domain socket (`/tmp/.X11-unix`).

```mermaid
flowchart TB
    subgraph HOST["LINUX OPERATOR WORKSTATION // HOST OS"]
        X11["X11 Display Server<br/>(/tmp/.X11-unix Socket)"]
        VOL[("Encrypted Host Volume<br/>Workspace & Loot Persistence")]
        NIC["Host Network Interface<br/>(Bridge / Tun0 VPN Interface)"]
    end

    subgraph DOCKER["DOCKER ENGINE // ISOLATED BRIDGE NETWORK (secops_net)"]
        direction TB
        
        subgraph APP["CONTAINER 01 // simonthomas/armitage (Kali / Debian Base)"]
            GUI["Armitage Java GUI Client<br/>(X11 Forwarded Display)"]
            MSF["Metasploit Framework & msfrpcd<br/>(RPC Daemon :55553)"]
            TOOLS["Network Recon & Exploit Modules<br/>(Nmap · Auxiliary · Post-Exploitation)"]
        end

        subgraph DB["CONTAINER 02 // postgres:alpine (Telemetry & State)"]
            PG[("PostgreSQL Database (:5432)<br/>Hosts · Services · Vulns · Loot")]
        end
    end

    subgraph TARGET["AUTHORIZED TARGET ENVIRONMENT"]
        LAB["Isolated Lab / Client Audit Subnet"]
    end

    GUI <==>|"Unix Domain Socket IPC<br/>($DISPLAY Forwarding)"| X11
    GUI <-->|"Local Loopback / RPC"| MSF
    MSF <==>|"TCP :5432 (msf_database)"| PG
    MSF -->|"Read / Write Artifacts"| VOL
    PG -->|"Persistent DB Storage"| VOL
    TOOLS <==>|"NAT Bridge / Host Net"| NIC
    NIC <==>|"Authorized Audit Traffic"| LAB
```

---

### `[03 // IMAGE MATRIX & SPECIFICATIONS]`

| Image / Build Target | Registry / Tag | Base Layer | Key Daemons & Stack | Operational Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Armitage & Metasploit Suite** | [`simonthomas/armitage:latest`](https://hub.docker.com/r/simonthomas/armitage) | Kali Linux / Debian | `msfrpcd`, `armitage`, `nmap`, `openjdk`, `postgresql-client` | Turnkey graphical red-team collaboration & network exploitation workspace (**10,000+ pulls**). |
| **PostgreSQL MSF Backend** | `postgres:15-alpine` | Alpine Linux | `postgres` (`:5432`) | High-speed relational indexing for discovered hosts, open ports, service banners, and audit artifacts. |
| **Infrastructure Base Builds** | `t0m-a/docker-image-builds` | Debian / Alpine | Hardened CLI utilities, reverse-proxy & service templates | Reproducible service containers for local staging, network diagnostics, and daemon isolation. |

---

### `[04 // DEPLOYMENT & RUNTIME INSTRUCTIONS]`

#### `// 04.1 PREREQUISITES & X11 SOCKET AUTHORIZATION`
To render containerized graphical interfaces (`Armitage`) seamlessly on a Linux host without SSH X11 overhead, grant local Docker container root access to your host X server prior to launch:

```bash
# 1. Verify Docker Engine & Compose availability
docker --version && docker compose version

# 2. Authorize local Docker containers to connect to the host X11 socket
xhost +local:docker
```

---

#### `// 04.2 OPTION A: RAPID DEPLOYMENT VIA DOCKER HUB (STANDALONE)`
Pull the pre-built image directly from Docker Hub (`simonthomas/armitage`) and initialize the container with X11 socket mounting:

```bash
# Pull the latest verified build from Docker Hub
docker pull simonthomas/armitage:latest

# Launch container with X11 display forwarding and persistent workspace mount
docker run --rm -it \
  --name armitage-secops \
  --hostname edge-audit-node \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v "$(pwd)/workspace:/root/.msf4" \
  --network bridge \
  simonthomas/armitage:latest
```

---

#### `// 04.3 OPTION B: DETERMINISTIC ORCHESTRATION VIA DOCKER COMPOSE`
For full workspace persistence with a dedicated PostgreSQL container, deploy using `docker-compose.yml`:

```yaml
version: "3.8"

services:
  msf-db:
    image: postgres:15-alpine
    container_name: msf-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: msf
      POSTGRES_PASSWORD: msf_sovereign_password
      POSTGRES_DB: msf_database
    volumes:
      - msf_pgdata:/var/lib/postgresql/data
    networks:
      - secops_net
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U msf -d msf_database"]
      interval: 5s
      timeout: 5s
      retries: 5

  armitage:
    image: simonthomas/armitage:latest
    container_name: armitage-console
    depends_on:
      msf-db:
        condition: service_healthy
    environment:
      DISPLAY: ${DISPLAY}
      DATABASE_URL: postgres://msf:msf_sovereign_password@msf-db:5432/msf_database
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix:rw
      - ./workspace:/root/.msf4
    networks:
      - secops_net
    stdin_open: true
    tty: true

networks:
  secops_net:
    driver: bridge

volumes:
  msf_pgdata:
```

Launch and manage the stack:

```bash
# Start the database and Armitage environment
docker compose up -d

# Attach to the interactive container session
docker attach armitage-console
```

---

#### `// 04.4 OPTION C: LOCAL COMPILATION FROM SOURCE (DOCKERFILE)`
To audit the build instructions or compile custom layers locally:

```bash
# 1. Clone the repository
git clone [https://github.com/t0m-a/docker-image-builds.git](https://github.com/t0m-a/docker-image-builds.git)
cd docker-image-builds

# 2. Build the image locally with no cache
docker build --no-cache -t local/armitage:custom .

# 3. Verify compiled image layers
docker history local/armitage:custom
```

---

### `[05 // SECURITY HARDENING & OPERATOR HYGIENE]`

1. **Revoke X11 Socket Access Post-Session:** Once your audit session concludes, immediately revoke local container access to your host X11 display server:
   ```bash
   xhost -local:docker
   ```
2. **Ephemeral State & Volume Sanitization:** Keep target engagement data strictly inside encrypted host volumes (`./workspace`) and purge ephemeral containers and unused networks after each engagement:
   ```bash
   docker compose down -v --remove-orphans
   ```
3. **Network Namespace Isolation:** By default, containers bind to the isolated `secops_net` bridge. Only attach `--network host` when conducting authorized local L2/ARP discovery or binding listeners to a dedicated VPN interface (`tun0`).

---

### `[06 // ARCHITECT & DIRECT INGESTION PATHWAYS]`

Engineered and maintained by **Thomas Mathieu Simon** — Systems Architect · NOC Engineer · AI Context Engineer.

* **Technical Portfolio & Dossiers:** [https://tsimon.me](https://tsimon.me)
* **Live Edge Telemetry Node:** [https://pi.tsimon.me](https://pi.tsimon.me)
* **Sovereign Search & RAG Node:** [https://search.tsimon.me](https://search.tsimon.me)
* **Civic Pedagogy Lab:** [https://minkalab.net](https://minkalab.net)
* **Direct Electronic Mail:** [contact@tsimon.me](mailto:contact@tsimon.me) // [hello@tsimon.me](mailto:hello@tsimon.me)
* **PGP Public Key (`0xA1048A81B9AEA757`):** `BDFC AB33 0606 4875 55F0 C3C6 A104 8A81 B9AE A757`
