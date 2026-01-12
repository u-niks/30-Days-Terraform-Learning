# Output Account Details
output "account_details" {
    description = "Account Details of Currently Login User"
    value       = data.aws_caller_identity.current
}

# Output All User Details
output "users_details" {
    description = "All IAM users with all their attached tags"
    value       = {
        for username, user in aws_iam_user.users :
        username => user.tags_all
    }
}

# Output User Auto Generated Password
output "user_password" {
    description = "User Auto Generated Password"
    value       = {
        for user, profile in aws_iam_user_login_profile.user_login_profile :
            user => "Password created - user must reset on first login"
    }

    sensitive = true
}
