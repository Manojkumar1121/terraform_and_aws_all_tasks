variable "environments" {
  description = "Map of environment configurations"
  type = map(object({
    bucket_suffix = string
    versioning    = bool
    users         = list(string)
    lifecycle_rules = list(object({
      id     = string
      status = string
      prefix = string
      days   = number
    }))
  }))
  default = {
    dev = {
      bucket_suffix = "data"
      versioning    = false
      users         = ["alice", "bob"]
      lifecycle_rules = [
        {
          id     = "log-expiration"
          status = "Enabled"
          prefix = "logs/"
          days   = 30
        }
      ]
    }
    prod = {
      bucket_suffix = "data"
      versioning    = true
      users         = ["bob", "charlie"]
      lifecycle_rules = [
        {
          id     = "archive"
          status = "Enabled"
          prefix = ""
          days   = 90
        }
      ]
    }
  }
}
