import boto3

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
print(response)