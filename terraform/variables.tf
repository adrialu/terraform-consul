variable "os_auth_url" {
  description = "Identity authentication URL. Same as OS_AUTH_URL environment variable."
}

variable "os_region_name" {
  description = "Specific region name, if your cloud has multiple regions. Same as OS_REGION_NAME environment variable."
}

variable "os_project_id" {
  description = "The ID of the project to log in with. Same as OS_PROJECT_ID environment variable."
}

variable "os_project_name" {
  description = "The name of the project to log in with. Same as OS_PROJECT_NAME environment variable."
}

variable "os_username" {
  description = "The user name to log in with. Same as OS_USERNAME environment variable."
}

variable "os_password" {
  description = "The password to log in with. Same as OS_PASSWORD environment variable."
}

variable "os_user_domain_name" {
  description = "The domain name where the user is located. Same as OS_USER_DOMAIN_NAME environment variable."
}

variable "os_project_domain_id" {
  description = "The domain ID where the project is located. Same as OS_PROJECT_DOMAIN_ID environment variable."
}
