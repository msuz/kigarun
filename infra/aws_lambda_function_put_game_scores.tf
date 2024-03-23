# Lambda 関数のソースコードを自動的に ZIP する
data "archive_file" "put_game_scores_zip" {
  type        = "zip"
  source_file = "${path.module}/../api/put_game_scores.py"
  output_path = "${path.module}/archive_file/put_game_scores.zip"
}

resource "aws_lambda_function" "put_game_scores" {
  function_name = "PutGameScores"
  role          = aws_iam_role.api_lambda_execution_role.arn
  handler       = "put_game_scores.lambda_handler"
  runtime       = "python3.12"

  # Lambda Layer で定義済みの共通処理
  layers = [aws_lambda_layer_version.common_layer.arn]

  # 更新されたZIPファイルのパス
  filename         = data.archive_file.put_game_scores_zip.output_path
  source_code_hash = data.archive_file.put_game_scores_zip.output_base64sha256
}

# Lambda関数の実行に必要なポリシーをアタッチ
resource "aws_lambda_permission" "api_gateway_put_game_scores" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put_game_scores.function_name
  principal     = "apigateway.amazonaws.com"
  # API GatewayのARNを指定（実際のARNに置き換えてください）
  # source_arn = "arn:aws:execute-api:region:account-id:api-id/*/*/*"
}