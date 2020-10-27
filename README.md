# Terraform Examples

Examples of IaC using terraform with multiple different providers.

Remember to create a `variables.tf` in the folder where you are going to run `terraform` with the following content:

```terraform
variable "vsphere_user" {
  type = string
  default = "username"
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_server" {
  type = string
  default = "vcenter.host.local"
}
```

The password will be prompted for when you apply the changes.
