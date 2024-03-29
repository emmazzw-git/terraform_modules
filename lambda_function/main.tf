resource "aws_lambda_layer_version" "this" {
  layer_name               = "${var.name}_dependencies"
  compatible_runtimes      = [var.runtime]
  description              = "Dependencies for ${var.name} Lambda Function"
  filename                 = var.layerFilename
  source_code_hash         = filebase64sha256(var.layerFilename)
}

resource "aws_lambda_function" "this" {
  function_name = var.name
  role          = aws_iam_role.this.arn
  description   = var.description
  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config == null ? [] : [var.dead_letter_config]
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }
  
  filename         = var.lambdaFilename
  handler          = var.handler
  layers           = local.layers
  memory_size      = var.memory_size
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.lambdaFilename)
  timeout          = var.timeout
  tags             = var.tags
  tracing_config {
    mode = "Active"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.retention_log_in_days
}

resource "aws_iam_role" "this" {
  name                = "${var.name}-role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = local.defaultLambdaPolicies

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      managed_policy_arns
    ]
  }
}

resource "aws_iam_policy" "this" {
  count  = length(var.custom_policies) > 0 ? 1 : 0
  policy = join("", data.aws_iam_policy_document.custom_policy_documents.*.json)
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = length(var.custom_policies) > 0 ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = join("", aws_iam_policy.this.*.arn)
}
