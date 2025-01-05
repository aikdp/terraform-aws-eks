#Create Web Apllication Load balancer
module "ingress_alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${local.resource_name}-ingress-alb"      #expense-dev-ingress-alb
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_id               #app-alb is for backend, so we rae using Private subnet (AZ)
  internal = false            #default is false. giving to public access, it is public right
  security_groups = [local.ingress_alb_sg_id]    # LIST sg is giving for ALB eqyalent to manually selecing sg id.
  create_security_group = false        #defalut is true, if not give flase, it will take default sg id
  enable_deletion_protection = false            #put this false, it will dlete, otherwise not delete
  tags = merge(
    var.common_tags,
    var.ingress_alb_tags
  )
}


#Creating WEB ALB listener using TERRAFORM

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.ingress_alb.arn    #check o/p attribute    arn--endpoint id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, iam from HTTP WEB Load Balancer</h1>"
      status_code  = "200"
    }
  }
}

#Create WEB ALB HTTPS listener 
resource "aws_lb_listener" "https" {
  load_balancer_arn = module.ingress_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.https_certificate_arn   #need to provide certificate arn if we take 443 in listener
  # alpn_policy       = "HTTP2Preferred"


  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from WEB ALB HTTPS</h1>"
      status_code  = "200"
    }
  }
}

#Create RECORDS for Hostpath
#Creating CNAME
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "expense-${var.environment}"  # expense-dev
      type    = "A"
      alias = {
        name =  module.ingress_alb.dns_name
        zone_id =  module.ingress_alb.zone_id    # This belongs ALB internal hosted zone, not ours
      }
      allow_overwrite = true
    }
  ]
}


#Create TARGET GROUP for app alb
resource "aws_lb_target_group" "expense" {
  name        = local.resource_name
  port        = 80  #should be  80  FE server is listening on port 80 right
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"    ##In VM target type is instance but in pods target type is: ip based  #here we have pods in place of VM or instances. Target typoe is IP, 

  health_check {    
    healthy_threshold = 2   #No. of consecutive health check success required 
    unhealthy_threshold = 2
    interval = 5    
    matcher = "200-299"
    path = "/"    #not health  
    port = 80
    protocol = "HTTP"
    timeout = 4
  }
}

#10. Craete ALb Listener Rule
resource "aws_lb_listener_rule" "expense" {
  listener_arn = aws_lb_listener.https.arn    #provide HTTPS listener arn
  priority     = 100    #low priority evaluted first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.expense.arn
  }

  condition {
    host_header {
      values = ["${var.project_name}-${var.environment}.${var.zone_name}"]        #expense-dev.telugudevops.online
    }
  }
}



# http://expense-dev.telugudevops.online ==>r53--> Web ALB--> TG-->Listener and rule -->if helathy--> Hello, I am from WEB ALB HTTP

# https://expense-dev.telugudevops.online ==>r53--> Web ALB--> TG-->Listener and rule -->if helathy--> Hello, I am from WEB ALB HTTPs

