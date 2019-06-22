variable "ssh_public_key_filepath" {
    description = "Filepath for the ssh public key"
    type = "string"

    default = "centos.pub"
}

variable "instance_count" {
  default = "3"
}