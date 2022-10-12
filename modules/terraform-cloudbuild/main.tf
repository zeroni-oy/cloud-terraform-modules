locals {
  default_build_init  = ["init", "-backend-config=bucket=${var.state_bucket}"]
  default_build_plan  = ["plan", "-no-color", "-input=false", "-out=plan.tfplan"]
  default_build_apply = ["apply", "-no-color", "-input=false", "--auto-approve", "plan.tfplan"]
}

resource "google_cloudbuild_trigger" "plan" {
  project     = var.project_id
  name        = "${var.repo_name}-${var.name}-plan"
  location    = "global"
  description = "Terraform CI/CD for ${var.repo_name}. Managed by Terraform."

  github {
    owner = var.repo_owner
    name  = var.repo_name
    push {
      branch = "^feature/(.*)$"
    }
  }

  included_files = var.terraform_dir != "" ? [var.terraform_dir] : []

  build {
    step {
      name       = "hashicorp/terraform:1.3.0"
      entrypoint = "terraform"
      args       = tolist(local.default_build_init)
      dir        = var.terraform_dir != "" ? var.terraform_dir : null
    }

    step {
      name       = "hashicorp/terraform:1.3.0"
      entrypoint = "terraform"
      args       = tolist(local.default_build_plan)
      dir        = var.terraform_dir != "" ? var.terraform_dir : null
    }

    options {
      logging = "CLOUD_LOGGING_ONLY"
    }
  }

  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account}"

  # Build logs will be sent back to GitHub as part of the checkrun result
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
}

resource "google_cloudbuild_trigger" "apply" {
  project     = var.project_id
  name        = "${var.repo_name}-${var.name}-plan"
  location    = "global"
  description = "Terraform CI/CD for ${var.repo_name}. Managed by Terraform."

  github {
    owner = var.repo_owner
    name  = var.repo_name
    push {
      branch = var.branch_regex
    }
  }

  included_files = var.terraform_dir != "" ? [var.terraform_dir] : []

  build {
    step {
      name       = "hashicorp/terraform:1.3.0"
      entrypoint = "terraform"
      args       = tolist(local.default_build_init)
      dir        = var.terraform_dir != "" ? var.terraform_dir : null
    }
    step {
      name       = "hashicorp/terraform:1.3.0"
      entrypoint = "terraform"
      args       = tolist(local.default_build_plan)
      dir        = var.terraform_dir != "" ? var.terraform_dir : null
    }
    step {
      name       = "hashicorp/terraform:1.3.0"
      entrypoint = "terraform"
      args       = tolist(local.default_build_apply)
      dir        = var.terraform_dir != "" ? var.terraform_dir : null
    }

    options {
      logging = "CLOUD_LOGGING_ONLY"
    }
  }

  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account}"
}
