provider "aws" {
  region = "ap-south-1"
}


#Here firstly the s3 bucket is created then only ec2 is created 
resource "aws_instance" "Ec2" {
  ami = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"
  depends_on = [ aws_s3_bucket.bucket ]
}


resource "aws_s3_bucket" "bucket" {
  bucket = "s3bucketfordepends.com"
}