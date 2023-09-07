variable "ami" {
  default = "ami-03f65b8614a860c29"
  
}
variable "instance-type" {
  default = "t3.medium"
}
variable "kubenetes-key" {
  default     = "~/keypairs/kubenetes-key.pub"
  description = "path to my keypairs"
}
variable "keyname" {
  default = "kubenetes-key"
}
#test