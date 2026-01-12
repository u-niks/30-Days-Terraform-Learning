# Get AWS Account ID
data "aws_caller_identity" "current" {}

# Create IAM users
resource "aws_iam_user" "users" {
    for_each = { for user in local.users_details : user.first_name => user }

    name = lower("${substr(each.value.first_name, 0, 1)}${each.value.last_name}")
    path = "/users/"

    tags = {
        "Display_Name"    = "${each.value.first_name} ${each.value.last_name}"
        "Department"      = each.value.department
        "Job_Title"       = each.value.job_title
        "Mobile_Number"   = each.value.mobile_number
        "Employee_Id"     = each.value.employee_id
        "Email"           = each.value.email
        "Office_Location" = each.value.office_location
        "Hire_Year"       = each.value.hire_year

    }
}

# Create IAM user login profile (password)
resource "aws_iam_user_login_profile" "user_login_profile" {
    for_each = aws_iam_user.users

    user                    = each.value.name
    password_reset_required = true

    lifecycle {
        ignore_changes = [
            password_length,
            password_reset_required
        ]
    }
}

# Create IAM Groups
resource "aws_iam_group" "education" {
    name = "Education"
    path = "/groups/"
}

resource "aws_iam_group" "managers" {
    name = "Managers"
    path = "/groups/"
}
resource "aws_iam_group" "accounting" {
    name = "Accounting"
    path = "/groups/"
}

# Add users to the Education group
resource "aws_iam_group_membership" "education_group_members" {
    name  = "Education_Group_Membership"
    group = aws_iam_group.education.name

    users = [ 
        for user in aws_iam_user.users : user.name if user.tags.Department == "Education"
    ]
}

# Add users to the Managers group
resource "aws_iam_group_membership" "managers_group_members" {
    name  = "Managers_Group_Membership"
    group = aws_iam_group.managers.name

    users = [
        for user in aws_iam_user.users : user.name if contains(keys(user.tags), "Job_Title") && can(regex("Manager|CEO", user.tags.Job_Title))
    ]
}

# Add users to the Accounting group
resource "aws_iam_group_membership" "accounting_group_memebers" {
    name  = "Accounting_Group_Membership"
    group = aws_iam_group.accounting.name

    users = [
        for user in aws_iam_user.users : user.name if user.tags.Department == "Accounting"
    ]
}


