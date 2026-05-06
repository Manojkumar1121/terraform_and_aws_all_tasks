
resource "aws_s3_bucket" "env_bucket" {
  for_each = var.environments

  bucket = "myapp-${each.key}-${each.value.bucket_suffix}"
}


resource "aws_s3_bucket_versioning" "env_bucket_versioning" {
  for_each = { for k, v in var.environments : k => v if v.versioning }

  bucket = aws_s3_bucket.env_bucket[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "env_bucket_lifecycle" {
  for_each = var.environments

  bucket = aws_s3_bucket.env_bucket[each.key].id

  dynamic "rule" {
    for_each = each.value.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      filter {
        prefix = rule.value.prefix
      }

      expiration {
        days = rule.value.days
      }
    }
  }
}


locals {
  all_users    = flatten([for env in values(var.environments) : env.users])
  unique_users = toset(distinct(local.all_users))
}

resource "aws_iam_user" "users" {
  for_each = local.unique_users

  name = each.value
}


resource "aws_iam_policy" "env_policy" {
  for_each = var.environments

  name        = "myapp-${each.key}-s3-policy"
  description = "Policy to access the ${each.key} S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.env_bucket[each.key].arn,
          "${aws_s3_bucket.env_bucket[each.key].arn}/*"
        ]
      }
    ]
  })
}


locals {
  user_env_pairs = flatten([
    for env_name, env_config in var.environments : [
      for user in env_config.users : {
        env  = env_name
        user = user
      }
    ]
  ])

  user_policy_attachments = {
    for pair in local.user_env_pairs : "${pair.user}-${pair.env}" => pair
  }
}

resource "aws_iam_user_policy_attachment" "user_attachment" {
  for_each = local.user_policy_attachments

  user       = aws_iam_user.users[each.value.user].name
  policy_arn = aws_iam_policy.env_policy[each.value.env].arn
}
