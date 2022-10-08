locals {
  vpc_id = "vpc-095b225fcfc1dfc13"

  route_table_id = {
    sbcntr_route_app = "rtb-0bf65af744b094b4b"
  }

  security_group_id = {
    egress = "sg-04062cfb0e6b3017f"
  }
}