output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_sn_pub_az1_id" {
  value = aws_subnet.sn_pub_az1.id
}

output "vpc_sn_pub_az2_id" {
  value = aws_subnet.sn_pub_az2.id
}

output "vpc_sn_priv_az1_id" {
  value = aws_subnet.sn_priv_az1.id
}

output "vpc_sn_priv_az2_id" {
  value = aws_subnet.sn_priv_az2.id
}