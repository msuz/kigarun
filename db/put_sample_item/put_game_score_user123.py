import boto3
import json

# DynamoDB テーブルの名前を設定
DYNAMODB_TABLE_NAME = 'GameScores'

# DynamoDB リソースを取得
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(DYNAMODB_TABLE_NAME)

# 書き込むデータを定義
item = {
    'UserId': 'user123',
    'GameTitle': 'Space Invaders',
    'TopScore': 9800
}

# データを DynamoDB に書き込む
response = table.put_item(Item=item)
pretty_json = json.dumps(response, indent=4)
print(pretty_json)