# Custom Allow S3 Policy
data "aws_iam_policy_document" "full_access_s3" {
    statement {
        sid     = "AllowFullS3"
        effect  = "Allow"
        actions = [
            "s3:*",
        ]
        resources = ["*"]
    }
}

# Create the managed policy
resource "aws_iam_policy" "full_access_s3" {
    name        = "Allow-Full-S3"
    description = "Allowing Full S3 Access to users"
    policy      = data.aws_iam_policy_document.full_access_s3.json
}

resource "aws_iam_group_policy_attachment" "education_full_s3_access_attach" {
    group      = aws_iam_group.education.name
    policy_arn = aws_iam_policy.full_access_s3.arn
}

resource "aws_iam_group_policy_attachment" "managers_full_s3_access_attach" {
    group      = aws_iam_group.managers.name
    policy_arn = aws_iam_policy.full_access_s3.arn
}

resource "aws_iam_group_policy_attachment" "accounting_full_s3_access_attach" {
    group      = aws_iam_group.accounting.name
    policy_arn = aws_iam_policy.full_access_s3.arn
}


# Create MFA Enforce Policy
data "aws_iam_policy_document" "enforce_mfa" {
    # AllowViewAccountInfo
    statement {
        sid     = "AllowViewAccountInfo"
        effect  = "Allow"
        actions = [
            "iam:GetAccountPasswordPolicy",
            "iam:ListVirtualMFADevices",
        ]
        resources = ["*"]
    }

    # AllowManageOwnPasswords
    statement {
        sid     = "AllowManageOwnPasswords"
        effect  = "Allow"
        actions = [
            "iam:ChangePassword",
            "iam:GetUser",
        ]
        resources = ["arn:aws:iam::*:user/users/$${aws:username}"]
    }

    # AllowManageOwnAccessKeys
    statement {
        sid     = "AllowManageOwnAccessKeys"
        effect  = "Allow"
        actions = [
            "iam:CreateAccessKey",
            "iam:DeleteAccessKey",
            "iam:ListAccessKeys",
            "iam:UpdateAccessKey",
        ]
        resources = ["arn:aws:iam::*:user/users/$${aws:username}"]
    }

    # AllowManageOwnSigningCertificates
    statement {
        sid     = "AllowManageOwnSigningCertificates"
        effect  = "Allow"
        actions = [
            "iam:DeleteSigningCertificate",
            "iam:ListSigningCertificates",
            "iam:UpdateSigningCertificate",
            "iam:UploadSigningCertificate",
        ]
        resources = ["arn:aws:iam::*:user/users/$${aws:username}"]
    }

    # AllowManageOwnSSHPublicKeys
    statement {
        sid     = "AllowManageOwnSSHPublicKeys"
        effect  = "Allow"
        actions = [
            "iam:DeleteSSHPublicKey",
            "iam:GetSSHPublicKey",
            "iam:ListSSHPublicKeys",
            "iam:UpdateSSHPublicKey",
            "iam:UploadSSHPublicKey",
        ]
        resources = ["arn:aws:iam::*:user/users/$${aws:username}"]
    }

    # AllowManageOwnServiceSpecificCredentials
    statement {
        sid     = "AllowManageOwnServiceSpecificCredentials"
        effect  = "Allow"
        actions = [
            "iam:CreateServiceSpecificCredential",
            "iam:DeleteServiceSpecificCredential",
            "iam:ListServiceSpecificCredentials",
            "iam:ResetServiceSpecificCredential",
            "iam:UpdateServiceSpecificCredential",
        ]
        resources = ["arn:aws:iam::*:user/users/$${aws:username}"]
    }

    # AllowManageOwnVirtualMFADevice
    statement {
        sid     = "AllowManageOwnVirtualMFADevice"
        effect  = "Allow"
        actions = [
        "iam:CreateVirtualMFADevice",
        "iam:DeleteVirtualMFADevice",
        ]
        resources = ["arn:aws:iam::*:mfa/$${aws:username}"]
    }

    # AllowManageOwnUserMFA
    statement {
        sid     = "AllowManageOwnUserMFA"
        effect  = "Allow"
        actions = [
            "iam:DeactivateMFADevice",
            "iam:EnableMFADevice",
            "iam:ListMFADevices",
            "iam:ResyncMFADevice",
        ]
        resources = ["arn:aws:iam::*:user/users/$${aws:username}"]
    }

    # Deny all actions unless MFA is present,
    # EXCEPT the minimal set for enrollment/bootstrap
    statement {
        sid    = "DenyAllExceptListedIfNoMFA"
        effect = "Deny"

        not_actions = [
            "iam:CreateVirtualMFADevice",
            "iam:EnableMFADevice",
            "iam:GetUser",
            "iam:ListMFADevices",
            "iam:ListVirtualMFADevices",
            "iam:ResyncMFADevice",
            "sts:GetSessionToken",
        ]

        resources = ["*"]

        condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["false"]
        }
    }
}

# Create the managed policy from the document
resource "aws_iam_policy" "enforce_mfa" {
    name        = "enforce-mfa-for-iam-users"
    description = "Restrict all actions unless MFA is present; allow only self-service/enrollment actions for the current user"
    policy      = data.aws_iam_policy_document.enforce_mfa.json
}

# Attach enforce_mfa policy to all users
resource "aws_iam_user_policy_attachment" "enforce_mfa_users" {
    for_each   = aws_iam_user.users
    user       = each.value.name
    policy_arn = aws_iam_policy.enforce_mfa.arn
}

