# API Gateway REST APIの作成
resource "aws_api_gateway_rest_api" "kigarun_api" {
  name        = "KigarunAPI"
  description = "API for Kigarun service"
}

# '/message' エンドポイントのリソースを作成
resource "aws_api_gateway_resource" "message_resource" {
  rest_api_id = aws_api_gateway_rest_api.kigarun_api.id
  parent_id   = aws_api_gateway_rest_api.kigarun_api.root_resource_id
  path_part   = "message"
}

# GET メソッドを '/message' エンドポイントに定義
resource "aws_api_gateway_method" "message_get" {
  rest_api_id   = aws_api_gateway_rest_api.kigarun_api.id
  resource_id   = aws_api_gateway_resource.message_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# '/message' エンドポイントに対するLambda統合を設定
resource "aws_api_gateway_integration" "message_integration" {
  rest_api_id             = aws_api_gateway_rest_api.kigarun_api.id
  resource_id             = aws_api_gateway_resource.message_resource.id
  http_method             = aws_api_gateway_method.message_get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST" # API GatewayからLambdaへはPOSTメソッドを使用する必要がある
  uri                     = aws_lambda_function.get_message.invoke_arn
  depends_on = [aws_lambda_function.get_message] # aws_lambda_function.get_message に依存
}

# '/game-scores' エンドポイントのリソースを作成
resource "aws_api_gateway_resource" "game_scores_resource" {
  rest_api_id = aws_api_gateway_rest_api.kigarun_api.id
  parent_id   = aws_api_gateway_rest_api.kigarun_api.root_resource_id
  path_part   = "game-scores"
}

# POST メソッドを '/game-scores' エンドポイントに定義
resource "aws_api_gateway_method" "game_scores_post" {
  rest_api_id   = aws_api_gateway_rest_api.kigarun_api.id
  resource_id   = aws_api_gateway_resource.game_scores_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# GET メソッドを '/game-scores' エンドポイントに定義
resource "aws_api_gateway_method" "game_scores_get" {
  rest_api_id   = aws_api_gateway_rest_api.kigarun_api.id
  resource_id   = aws_api_gateway_resource.game_scores_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# '/game-scores' エンドポイントに対する POST メソッドのLambda統合を設定
resource "aws_api_gateway_integration" "game_scores_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.kigarun_api.id
  resource_id             = aws_api_gateway_resource.game_scores_resource.id
  http_method             = aws_api_gateway_method.game_scores_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.add_game_scores.invoke_arn
  depends_on = [aws_lambda_function.add_game_scores] # aws_lambda_function.add_game_scores に依存
}

# '/game-scores' エンドポイントに対する GET メソッドのLambda統合を設定
resource "aws_api_gateway_integration" "game_scores_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.kigarun_api.id
  resource_id             = aws_api_gateway_resource.game_scores_resource.id
  http_method             = aws_api_gateway_method.game_scores_get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.get_game_scores.invoke_arn
  depends_on = [aws_lambda_function.get_game_scores] # aws_lambda_function.get_game_scores に依存
}

# APIデプロイメントの作成と'prod'ステージの設定
resource "aws_api_gateway_deployment" "kigarun_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.kigarun_api.id
  stage_name  = "prod"
  depends_on = [
    aws_api_gateway_integration.message_integration,
    aws_api_gateway_integration.game_scores_post_integration,
    aws_api_gateway_integration.game_scores_get_integration,
  ]
}
