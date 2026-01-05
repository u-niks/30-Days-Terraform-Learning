# Terraform Functions (Day 11-12)

## Console Commands

Basic String Manipulation Functions

```hcl
lower("HELLO WORLD")
max(5, 12, 9)
trim("  hello  ")
chomp("hello\n")
reverse(["a", "b", "c"])
```

## 📋 Functions Overview

| # |  | Functions | Difficulty | AWS Resources |
|---|------------|-----------|------------|---------------|
| 1 | Project Naming | `lower`, `replace` | ⭐ | Resource Group |
| 2 | Resource Tagging | `merge` | ⭐ | VPC |
| 3 | S3 Bucket Naming | `substr`, `replace`, `lower` | ⭐⭐ | S3 Bucket |
| 4 | Security Group Ports | `split`, `join`, `for` | ⭐⭐ | Security Group |
| 5 | Environment Lookup | `lookup` | ⭐⭐ | EC2 Instance |
| 6 | Instance Validation | `length`, `can`, `regex` | ⭐⭐⭐ | EC2 Instance |
| 7 | Backup Configuration | `endswith`, `sensitive` | ⭐⭐ | None |
| 8 | File Path Processing | `fileexists`, `dirname` | ⭐⭐ | None |
| 9 | Location Management | `toset`, `concat` | ⭐ | None |
| 10 | Cost Calculation | `abs`, `max`, `sum` | ⭐⭐ | None |
| 11 | Timestamp Management | `timestamp`, `formatdate` | ⭐⭐ | S3 Bucket |
| 12 | File Content Handling | `file`, `jsondecode` | ⭐⭐⭐ | Secrets Manager |

---

## 🚀 Quick Start

```bash
# Navigate to directory
cd /home/baivab/repos/Terraform-Full-Course-Aws/lessons/day11-12

# Initialize
terraform init

# Start with Example 1
terraform plan
terraform apply -auto-approve

# View outputs
terraform output

# Cleanup
terraform destroy -auto-approve
```

---

## 📖 Function Categories

### String Functions
`lower()`, `upper()`, `replace()`, `substr()`, `trim()`, `split()`, `join()`, `chomp()`

### Numeric Functions
`abs()`, `max()`, `min()`, `ceil()`, `floor()`, `sum()`
 
### Collection Functions
`length()`, `concat()`, `merge()`, `reverse()`, `toset()`, `tolist()`

### Type Conversion
`tonumber()`, `tostring()`, `tobool()`, `toset()`, `tolist()`

### File Functions
`file()`, `fileexists()`, `dirname()`, `basename()`

### Date/Time Functions
`timestamp()`, `formatdate()`, `timeadd()`art

### Validation Functions
`can()`, `regex()`, `contains()`, `startswith()`, `endswith()`

### Lookup Functions
`lookup()`, `element()`, `index()`

---

## 📁 Files

- `README.md` - This overview
- `provider.tf` - AWS provider setup
- `backend.tf` - S3 backend (optional)
- `variables.tf` - All example variables
- `main.tf` - All 12 examples (commented structure)
- `outputs.tf` - examples outputs (commented)
- `config.json` - data configuration file


---

## ✅ Examples Summary

### Example 1: Project Naming ⭐
Transform "Project ALPHA Resource" → "project-alpha-resource"

**Functions:** `lower()`, `replace()`  
**Status:** ✅ Active by default

### Example 2: Resource Tagging ⭐
Merge default and environment tags

**Function:** `merge()`

### Example 3: S3 Bucket Naming ⭐⭐
Sanitize bucket names for AWS compliance

**Functions:** `substr()`, `replace()`, `lower()`

### Example 4: Security Group Ports ⭐⭐
Transform "80,443,8080" into security group rules

**Functions:** `split()`, `join()`, `for`

### Example 5: Environment Lookup ⭐⭐
Select instance size by environment

**Function:** `lookup()`

### Example 6: Instance Validation ⭐⭐⭐
Validate instance type format

**Functions:** `length()`, `can()`, `regex()`

### Example 7: Backup Configuration ⭐⭐
Validate names and handle sensitive data

**Functions:** `endswith()`, `sensitive`

### Example 8: File Path Processing ⭐⭐
Check file existence and extract paths

**Functions:** `fileexists()`, `dirname()`

### Example 9: Location Management ⭐
Combine regions and remove duplicates

**Functions:** `toset()`, `concat()`

### Example 10: Cost Calculation ⭐⭐
Process costs with credits

**Functions:** `abs()`, `max()`, `sum()`

### Example 11: Timestamp Management ⭐⭐
Format timestamps for resources and tags

**Functions:** `timestamp()`, `formatdate()`

### Example 12: File Content Handling ⭐⭐⭐
Read JSON config and store in Secrets Manager

**Functions:** `file()`, `jsondecode()`, `jsonencode()`

---

## 📚 Resources

- [Terraform Functions Docs](https://www.terraform.io/language/functions)
- [Terraform Console](https://www.terraform.io/cli/commands/console)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
