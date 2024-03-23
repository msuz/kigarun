import json
import boto3
from decimal import Decimal

# DecimalをJSONで扱える型に変換
def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)  # 精度の問題を避けるためfloatに
    raise TypeError("Unsupported type")

# DynamoDB クライアントを初期化
def get_dynamodb_table(table_name='GameScores'):
    dynamodb = boto3.resource('dynamodb')
    return dynamodb.Table(table_name)

def lambda_handler(event, context):
    table = get_dynamodb_table()  # テーブル取得
    
    # DynamoDBテーブル全スキャン
    response = table.scan()
    
    # scan結果をJSON形式でレスポンス
    # Decimal型はdecimal_defaultで変換
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(response['Items'], default=decimal_default)
    }