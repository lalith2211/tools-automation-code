resource "aws_instance" "vm" {
  ami                     = data.aws_ami.example.id
  instance_type           = var.instance_type
  vpc_security_group_ids  = [data.aws_security_group.selected.id]
  iam_instance_profile    = aws_iam_instance_profile.profile.name

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "persistent"
      instance_interruption_behavior = "stop"
    }
  }

  tags = {
    Name = var.tool_name
  }
}

resource "aws_route53_record" "domain" {
  zone_id = var.zone_id
  name    = var.tool_name
  type    = "A"
  ttl     = 3
  records = [aws_instance.vm.public_ip]
}

resource "aws_route53_record" "domain-internal" {
  zone_id = var.zone_id
  name    = "${var.tool_name}-internal"
  type    = "A"
  ttl     = 30
  records = [aws_instance.vm.private_ip]
}

resource "aws_iam_role" "role" {
  name = "${var.tool_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name        = "${var.tool_name}-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = concat(var.dummy_policy_list,var.policy_resource_list)
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.tool_name}_profile"
  role = aws_iam_role.role.name
}