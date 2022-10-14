locals {
  vpc_id = "vpc-095b225fcfc1dfc13"

  route_table_id = {
    sbcntr_route_app = "rtb-0bf65af744b094b4b"
  }

  security_group_id = {
    container = "sg-0cb41274911be6ec8"
    front_container = "sg-09ac5f3a8585f815d"
    egress    = "sg-04062cfb0e6b3017f"
    ingress   = "sg-02d1208386f83fd17"
    internal  = "sg-0e0742955522547aa"
  }

  subnet_ids = {
    container = [
      "subnet-06b0c0d55942e66ec", # sbcntr-subnet-private-container-1a
      "subnet-0a2c35141c30ae07d", # sbcntr-subnet-private-container-1c
    ]
    egress = [
      "subnet-0ea4ea3a3f297c8c9", # sbcntr-subnet-private-egress-1a
      "subnet-06aa2b02a9ec86c97", # sbcntr-subnet-private-egress-1c
    ]

    ingress = [
      "subnet-02b4d77231229d524", # sbcntr-subnet-public-ingress-1a
      "subnet-02d44f9970823d49b", # sbcntr-subnet-public-ingress-1c
    ]

    db = [
      "subnet-051947d563475bc15", # sbcntr-subnet-private-db-1a
      "subnet-0bab39175a7b40e87", # sbcntr-subnet-private-db-1c
    ]
  }
}