
# 🚀 Terraform & Infrastructure as Code (IaC)

## 🧩 What Is Infrastructure as Code (IaC)

**Infrastructure as Code (IaC)** is the practice of defining, provisioning, and managing infrastructure—compute, networking, storage, identity, and platform services—using configuration files that are treated as software artifacts. Instead of hand‑configuring resources in a cloud provider’s web console, you express the **desired state** of your environment in human‑readable files. An IaC tool reads those files and reconciles reality with your intent by creating, updating, or removing resources as needed.

IaC shifts infrastructure work from a manual, click‑driven activity to a **repeatable, auditable, and collaborative** process. Because the configuration is code, it can live in version control, be peer‑reviewed, and move through environments with the same rigor as application changes. This reduces configuration drift, minimizes human error, and shortens the time from idea to reliable infrastructure. The core mindset is **declarative**: describe *what* the end state should be, not the exact steps to reach it. The tool computes the necessary actions, ensuring idempotence and predictability.

---

## 🛠️ IaC Tools

### 1) Terraform (Universal & Most Popular)
Terraform is a **cloud‑agnostic** IaC tool that uses a declarative language to manage resources across many providers. “Universal” here means you can use the same workflow for AWS, Azure, Google Cloud, Kubernetes, and a wide range of SaaS platforms. Teams adopt Terraform to standardize operational practices across heterogeneous environments while keeping the configuration **readable**, **extensible**, and **portable**.

### 2) Pulumi (Universal)
Pulumi is also multi‑cloud but lets you define infrastructure in **general‑purpose programming languages** such as TypeScript, Python, Go, and C#. This appeals to teams that prefer familiar language constructs and richer abstractions while still benefiting from a universal provider model. The result is flexibility in how you model infrastructure while retaining a consistent workflow across clouds.

### 3) Azure ARM | Bicep (Azure Only)
For Azure, the native IaC options are **ARM templates** and **Bicep**. ARM uses JSON to declaratively specify Azure resources, while Bicep provides a concise domain‑specific language that compiles to ARM. Being **Azure‑only**, these tools offer deep alignment with Azure services and deployment patterns, making them natural choices for teams fully invested in the Azure ecosystem.

### 4) AWS CloudFormation, AWS CDK, SAM (AWS Only)
On AWS, the first‑party suite includes **CloudFormation** for declarative templates, the **Cloud Development Kit (CDK)** for defining infrastructure using general‑purpose languages that synthesize to CloudFormation, and **SAM** for serverless‑focused definitions (Lambda, API Gateway, and related services). These **AWS‑only** tools deliver strong, native integrations and conventions tailored to AWS workloads.

### 5) Deployment Manager, Config Controller/Connector (GCP Only)
Google Cloud offers **Deployment Manager** for declarative configuration and **Config Controller/Connector** for managing GCP resources via the Kubernetes Resource Model. As **GCP‑only** tools, they align tightly with Google Cloud’s services and can integrate with Kubernetes‑centric workflows where desired.

---

## ✅ Why We Need IaC (Terraform by HashiCorp)

**Terraform by HashiCorp** is one of the most widely used IaC tools. It enables you to define infrastructure using **human‑readable code**, and it supports multiple cloud providers such as **AWS**, **Azure**, and **Google Cloud**. Terraform allows you to automate the **provisioning**, **maintenance**, and **destruction** of resources, making it an essential tool for **DevOps** teams.

The value proposition is straightforward. As cloud footprints grow in breadth and complexity, manual setup becomes brittle and opaque. With Terraform, the infrastructure definition lives in files that anyone on the team can read, review, and improve. The same configuration can be promoted from development to production with confidence, and rollbacks become controlled changes rather than frantic console reversals. Because Terraform spans multiple providers, you keep a **single operational model** even when your architecture spans clouds or integrates managed services from different vendors.

---

## ⚠️ Challenges When We Create Infrastructure from Web Console

1. **Time**  
   Clicking through forms, tabs, and nested settings for every change is slow. Routine tasks such as spinning up test environments become time‑consuming, and the overhead grows with scale and complexity.

2. **People**  
   Console‑driven workflows create **tribal knowledge**. Only a few people know the exact sequence of steps, leaving bottlenecks and fragile processes that struggle when those individuals are unavailable.

3. **Cost**  
   Manually created resources are easy to forget. Orphaned instances, unused storage, and mis‑sized services persist without a clear teardown path. Inconsistent tagging makes cost visibility harder and optimization sporadic.

4. **Repetitive**  
   Re‑creating similar environments by hand invites inconsistency. Tiny differences—regions, security rules, or parameter values—creep in and cause elusive bugs, eroding trust in environment parity.

5. **Human Error**  
   Manual entry is fallible. Typos, omitted dependencies, or incorrect options can compromise reliability, performance, or security—often discovered late in the delivery cycle.

6. **Insecure**  
   Security relies on **consistency** and **least privilege**. Ad‑hoc provisioning can overlook encryption, logging, or policy baselines, leaving gaps that are difficult to detect and audit.

7. **It Works on My Machine**  
   Manually produced environments may function for one operator or one moment in time but resist reliable reproduction elsewhere. Without code as a shared source of truth, success is not portable.

---

## 🌟 How Terraform Helps

1. **Save Time**  
   Declarative files replace click‑ops. Once written, configurations can be applied repeatedly, compressing lead time for provisioning and updates.

2. **Consistent Envs**  
   The same inputs produce the same outcomes. Differences become explicit variables instead of accidental drift, improving reliability across dev, staging, and prod.

3. **Write Once, Deploy Many**  
   A single configuration can underpin multiple environments. You vary only what must differ—names, sizes, or regions—while reusing the core definitions.

4. **Track of Changes, Version Control**  
   Because infrastructure is code, every modification is **diffed**, **reviewed**, and **audited**. The planning step shows proposed changes before execution, aligning work with intent.

---

## 🔧 How Terraform Works

Terraform uses a **declarative approach** to manage infrastructure. You define the **desired state**—resources, properties, and relationships—and Terraform determines how to reconcile the current environment with that specification. If something is missing, Terraform plans to create it. If attributes differ, it plans to update them. If an item is no longer declared, it plans to destroy it.

This model emphasizes **intent and idempotence**. Rather than scripting step‑by‑step procedures, you describe outcomes and let Terraform compute the dependency graph and order of operations. Before changes occur, a planning phase previews the exact actions, offering transparency and a chance to verify that the plan matches expectations. Over time, as configurations evolve, Terraform continually realigns real infrastructure to match what the code describes.

---

## 🔁 Terraform Workflow

1. **Write Configuration File `.tf`**  
   Capture your infrastructure as code in one or more `.tf` files. You can use the CLI or a CI/CD pipeline to process these files and create infrastructure from them.

2. **`terraform init`**  
   Initialize the working directory, download referenced providers, and set up any configured backends so Terraform can manage the resources you described.

3. **`terraform validate`**  
   Check that your configuration is structurally sound—syntax is correct and resource definitions align with expected schemas—before planning changes.

4. **`terraform plan`**  
   Compare the desired state to the current state and preview the actions needed to align them. The plan lists creates, updates, and destroys so you can review intent.

5. **`terraform apply`**  
   Execute the approved plan. Terraform carries out the necessary operations to converge on the desired state, creating or modifying resources as specified.

6. **`terraform destroy`**  
   Tear down resources managed by the current configuration in a controlled manner, preventing orphaned components and keeping costs in check.

---

## 🗂️ The Terraform State File

The **state file** is a key component of Terraform. It tracks the resources Terraform manages and their current state, maintaining a mapping between configuration and real‑world objects. When you run a plan or apply, Terraform consults state to understand what exists, which attributes are known, and how resources relate to one another.

State enables **drift detection**. If changes occur outside Terraform—such as manual edits in a web console—Terraform will surface those differences during planning and propose updates to restore alignment with the desired state. This keeps your environment consistent and reduces surprises during deployments.

State also improves **performance** by caching details that would otherwise require repeated provider calls. Most importantly, it provides a single source of truth for what Terraform believes it controls, which is essential for safe updates and clean destruction of resources that are no longer declared in configuration.

---

## 🧰 Setting Up Terraform

**MacOS:**

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Linux:**

```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Once installed, confirm terraform version by running:**
```bash
terraform --version
```