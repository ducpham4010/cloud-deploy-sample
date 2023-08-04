provider "aws" {
  region = "ap-southeast-1"
}
/* Terraform cung cấp cho ta một block tên là data, 
  được dùng để gọi API lên hạ tầng thông qua Provider của ta 
  và lấy thông tin về một resource nào đó 
*/
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] 
}

/* resource "aws_instance" "hello" {
  count         = 2
  ami           = "ami-03ae37b34d7fea1cd"
  instance_type = var.instance_type
} */

/* Thuộc tính count là một Meta Argument, là một thuộc tính trong Terraform chứ không phải của resource type thuộc Provider */
resource "aws_instance" "hello" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
}

/* output "ec2" {
  value = {
    public_ip = [ for v in aws_instance.hello : v.public_ip ]
  }
} */

/* Hàm format sẽ giúp ta nối chuỗi, cập nhật output lại như sau: */

output "ec2" {
  value = { for i, v in aws_instance.hello : format("public_ip%d", i + 1) => v.public_ip }
}