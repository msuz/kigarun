# Lambda 関数のソースコードを自動的に ZIP する
data "archive_file" "get_message_zip" {
  type        = "zip"
  source_file = "${path.module}/../api/get_message.py"
  output_path = "${path.module}/archive_file/get_message.zip"
}

resource "aws_lambda_function" "get_message" {
  function_name = "GetMessage"
  role          = aws_iam_role.api_lambda_execution_role.arn
  handler       = "get_message.lambda_handler"
  runtime       = "python3.12"

  # 更新されたZIPファイルのパス
  filename         = data.archive_file.get_message_zip.output_path
  source_code_hash = data.archive_file.get_message_zip.output_base64sha256
}

# Lambda関数の実行に必要なポリシーをアタッチ
resource "aws_lambda_permission" "api_gateway_get_message" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_message.function_name
  principal     = "apigateway.amazonaws.com"
  # API GatewayのARNを指定（実際のARNに置き換えてください）
  # source_arn = "arn:aws:execute-api:region:account-id:api-id/*/*/*"
}