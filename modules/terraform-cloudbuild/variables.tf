
variable "project_id" {
  type        = string
  description = "project id to create triggers in."
}

variable "repo_owner" {
  type        = string
  description = "GitHub Organization that owns the repository"
}

variable "repo_name" {
  type        = string
  description = "Repo name to filter the trigger on"
}

variable "branch_regex" {
  type    = string
  default = "^master$"
}

variable "name" {
  type        = string
  default     = "default"
  description = "Additional name to add to the trigger path. Useful when specifying multiple triggers with terraform_dir. (defaeults to 'default')"
}

variable "repo_branch" {
  type        = string
  default     = "master"
  description = "branch name to apply from (default 'master'.)"
}

variable "state_bucket" {
  type        = string
  description = "link to state bucket"
}

variable "terraform_dir" {
  type        = string
  default     = "/"
  description = "root directory of the terraform to trigger from"
}


variable "service_account" {
  type        = string
  description = "service account that CloudBuild will assume and execute from"
}

variable "included_files" {
  type        = list(string)
  default     = ["**"]
  description = "Optionally Glob path for filtering included files"
}


variable "terraform_version" {
  type        = string
  default     = "1.3.4"
  description = "Version of Terraform to use in steps."
}
