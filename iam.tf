#ROLES
resource "aws_iam_role" "lambda-iam-role" {
  name = "wasteless_lambda_role"
  
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

#POLICIES
resource "aws_iam_role_policy" "s3-lambda-policy" {
  name = "s3_lambda_policy"
  role = "${aws_iam_role.lambda-iam-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject", "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::${var.s3_bucket}" 
    }
  ]
}
EOF
}

