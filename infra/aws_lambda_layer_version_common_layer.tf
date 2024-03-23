# Lambda Layer 用のアーカイブを定義
data "archive_file" "common_layer" {
  type        = "zip"
  source_dir  = "${path.module}/../api/libs"
  output_path = "${path.module}/archive_file/common_layer.zip"
}

# Lambda Layer を作成
resource "aws_lambda_layer_version" "common_layer" {
  layer_name    = "CommonLayer"
  description   = "Lambda Layer containing common libraries"
  filename      = data.archive_file.common_layer.output_path

  compatible_runtimes = ["python3.12"]

  # Lambda Layer のソースコード更新を検出するためのハッシュ値
  source_code_hash = data.archive_file.common_layer.output_base64sha256
}