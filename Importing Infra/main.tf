provider "aws" {
  region = "ap-south-1"
}

import {
  id = "i-0bae4c498c5259145"
  to = aws_instance.demo
}
