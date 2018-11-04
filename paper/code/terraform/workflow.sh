# write definition file
vim main.tf
# initialize terraform, downloading any plugins used
terraform init
# preview changes before applying them
terraform plan
# apply changes
terraform apply
# destroy the infrastructure
terraform destroy