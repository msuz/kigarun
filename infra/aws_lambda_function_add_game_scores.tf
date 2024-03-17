resource "aws_lambda_function" "add_game_scores" {
  function_name = "AddGameScores"
  role          = aws_iam_role.api_lambda_execution_role.arn
  handler       = "add_game_scores.lambda_handler"
  runtime       = "python3.12"

  # 更新されたZIPファイルのパス
  filename         = "${path.module}/../api/add_game_scores.zip"
  source_code_hash = filebase64sha256("${path.module}/../api/add_game_scores.zip")
}

# Lambda関数のコードを含むZIPファイルを作成
resource "null_resource" "lambda_zip" {
  triggers = {
    file_checksum = filemd5("${path.module}/../api/add_game_scores.py")
  }

  provisioner "local-exec" {
    command = "cd ${path.module}/../api && zip add_game_scores.zip add_game_scores.py"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${path.module}/../api/add_game_scores.zip"
  }
}

# Lambda関数の実行に必要なポリシーをアタッチ
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_game_scores.function_name
  principal     = "apigateway.amazonaws.com"
  # API GatewayのARNを指定
  # source_arn = "arn:aws:execute-api:region:account-id:api-id/*/*/*"
}