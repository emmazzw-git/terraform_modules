locals {
  lambdaInsightsLayers = {
    us-east-1      = "arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:16"
    us-east-2      = "arn:aws:lambda:us-east-2:580247275435:layer:LambdaInsightsExtension:16"
    us-west-1      = "arn:aws:lambda:us-west-1:580247275435:layer:LambdaInsightsExtension:16"
    us-west-2      = "arn:aws:lambda:us-west-2:580247275435:layer:LambdaInsightsExtension:16"
    af-south-1     = "arn:aws:lambda:af-south-1:012438385374:layer:LambdaInsightsExtension:9"
    ap-east-1      = "arn:aws:lambda:ap-east-1:519774774795:layer:LambdaInsightsExtension:9"
    ap-south-1     = "arn:aws:lambda:ap-south-1:580247275435:layer:LambdaInsightsExtension:16"
    ap-northeast-2 = "arn:aws:lambda:ap-northeast-2:580247275435:layer:LambdaInsightsExtension:16"
    ap-southeast-1 = "arn:aws:lambda:ap-southeast-1:580247275435:layer:LambdaInsightsExtension:16"
    ap-southeast-2 = "arn:aws:lambda:ap-southeast-2:580247275435:layer:LambdaInsightsExtension:16"
    ap-northeast-1 = "arn:aws:lambda:ap-northeast-1:580247275435:layer:LambdaInsightsExtension:23"
    ca-central-1   = "arn:aws:lambda:ca-central-1:580247275435:layer:LambdaInsightsExtension:16"
    eu-central-1   = "arn:aws:lambda:eu-central-1:580247275435:layer:LambdaInsightsExtension:16"
    eu-west-1      = "arn:aws:lambda:eu-west-1:580247275435:layer:LambdaInsightsExtension:16"
    eu-west-2      = "arn:aws:lambda:eu-west-2:580247275435:layer:LambdaInsightsExtension:16"
    eu-south-1     = "arn:aws:lambda:eu-south-1:339249233099:layer:LambdaInsightsExtension:9"
    eu-west-3      = "arn:aws:lambda:eu-west-3:580247275435:layer:LambdaInsightsExtension:16"
    eu-north-1     = "arn:aws:lambda:eu-north-1:580247275435:layer:LambdaInsightsExtension:16"
    me-south-1     = "arn:aws:lambda:me-south-1:285320876703:layer:LambdaInsightsExtension:9"
    sa-east-1      = "arn:aws:lambda:sa-east-1:580247275435:layer:LambdaInsightsExtension:16"
  }

  layers = [
    aws_lambda_layer_version.this.arn,
    lookup(local.lambdaInsightsLayers, data.aws_region.current.name, "")
  ]

  defaultLambdaPolicies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess",
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
  ]
}
