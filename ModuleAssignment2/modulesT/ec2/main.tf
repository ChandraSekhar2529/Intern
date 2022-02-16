
resource "aws_instance" "instances"{
    instance_type  = "${var.instance_type}"
    ami = "${var.ami}"
    key_name = "Traveller"
    subnet_id = "${var.subnet_id}"

    tags = {
        Name = "Instance"
    }
}
