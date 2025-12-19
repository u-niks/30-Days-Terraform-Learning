# Day 08: Terraform Meta-Arguments

## 📁 Lesson Structure

```
day08/
├── backend.tf          # S3 backend configuration
├── provider.tf         # AWS provider configuration
├── variables.tf        # Input variables (list, set, map, object types)
├── local.tf            # Local values and common tags
├── main.tf             # Main resource definitions with count and for_each examples
├── output.tf           # Output values demonstrating for loops
└── README.md           # This file
```

### Meta-Arguments Overview

Meta-arguments are special arguments that can be used with **any resource type** to change the behavior of resources:

1. **count** - Create multiple resource instances based on a number
2. **for_each** - Create multiple resource instances based on a map or set
3. **depends_on** - Explicit resource dependencies

### COUNT Meta-Argument
```hcl
resource "aws_s3_bucket" "count_example" {
    count = length(var.s3_bucket_names_list)
    bucket = var.s3_bucket_names_list[count.index]
}
```

**Use cases:**
- Creating N identical resources
- Simple iteration over a list
- When numeric index is sufficient

**Limitations:**
- Removing items from the middle of a list causes resource recreation
- Less stable resource addressing
- Harder to maintain

### FOR_EACH Meta-Argument
```hcl
resource "aws_s3_bucket" "foreach_example" {
    for_each = var.s3_bucket_names_set
    bucket = each.value
}
```

**Use cases:**
- Creating resources from a map or set
- Stable resource addressing by key
- Production environments
- Complex resource configurations

**Benefits:**
- Adding/removing items doesn't affect other resources
- More readable resource references
- Better for production use

### DEPENDS_ON Meta-Argument
```hcl
resource "aws_s3_bucket" "dependant_bucket" {
    bucket = var.s3_bucket_names_depends[0]

    depends_on = [ aws_s3_bucket.primary_bucket]
}
```

**Use cases:**
- Explicit resource ordering
- Hidden dependencies not captured by references
- Ensuring resources are created in specific order

## 🔍 Key Differences: COUNT vs FOR_EACH

| Feature | COUNT | FOR_EACH |
|---------|-------|----------|
| **Input Type** | Number or list | Map or set |
| **Addressing** | Numeric index `[0]` | Key-based `["name"]` |
| **Stability** | Less stable | More stable |
| **Item Removal** | May recreate resources | Only removes specific resource |
| **Use Case** | Simple scenarios | Production environments |
| **Readability** | Index-based | Name-based (better) |
