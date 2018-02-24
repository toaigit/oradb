resource "aws_ebs_volume" "db" {
    availability_zone = "us-west-2a"
    size = 24 
    tags {
        Name = "oradb - Database Volume"
    }
}

resource "aws_ebs_volume" "backup" {
    availability_zone = "us-west-2a"
    size = 24 
    tags {
        Name = "oradb - Backup Volume"
    }
}
output "database_volume_output" {
  value = "${aws_ebs_volume.db.id}"
}
output "backup_volume_output" {
  value = "${aws_ebs_volume.backup.id}"
}
