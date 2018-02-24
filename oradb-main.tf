provider "aws" {
  region = "${var.region}"
}

resource "aws_autoscaling_group" "ServerGroup" {
  name_prefix               = "${var.asg_prefix}"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  desired_capacity          = "${var.asg_desired}"
  health_check_grace_period = "${var.health_check_grace_period}"
  vpc_zone_identifier       = ["${var.subnet1}"]
  launch_configuration      = "${aws_launch_configuration.LaunchConfig.name}"
  tag {
    key = "ASGName"
    value = "${var.host_name}"
    propagate_at_launch = true    
  }
  tag {
    key = "Name"
    value = "${var.host_name}"
    propagate_at_launch = true    
  }
  lifecycle {
    create_before_destroy = true
    }
}

resource "aws_launch_configuration" "LaunchConfig" {
  name_prefix                 = "${var.lc_prefix}"
  image_id                    = "${var.centos7_oradb_image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.dbserversg}"]
  iam_instance_profile        = "${var.iamrole}"
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }
  lifecycle {
    create_before_destroy = true
  }
#  user_data="${file("userdata.sh")}"
user_data = <<EOF
#cloud-config
runcmd:
- /bin/timedatectl set-timezone America/Los_Angeles
- echo PS1=\"[\\\\u@${var.host_name}]\" >> /etc/bashrc
- /bin/domainname "${var.local_domain_name}"
- /bin/hostname "${var.host_name}"
- mkdir /share
- mount  -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 "${var.nfs_share_volume}" /share
- chmod 700 "${var.nfs_userdata_dir}/runcmd"
- ${var.nfs_userdata_dir}/runcmd "${aws_ebs_volume.backup.id}" "${aws_ebs_volume.db.id}"

EOF

}
