import boto3
from decimal import Decimal

# Lambda Layer として定義する共通処理

# DynamoDBデータをJSON形式で扱うための変換処理
def convert_dynamo2json_default(obj):
    if isinstance(obj, Decimal): # Decimal型はFloat型へ
        return float(obj)
    raise TypeError

# DynamoDB クライアントを初期化
def get_dynamodb_table(table_name='GameScores'):
    dynamodb = boto3.resource('dynamodb')
    return dynamodb.Table(table_name)

# DynamoDB GameScoresテーブルに登録するデータのバリデーションチェック
def validate_input(body):
    required_fields = ['UserId', 'GameTitle']
    for field in required_fields:
        if field not in body or not (1 <= len(body[field]) <= 50):
            return False, f'{field} is required and must be between 1 and 50 characters.'
    
    if 'TopScore' not in body:
        body['TopScore'] = 0  # Set default value for TopScore
    
    # Allow only expected columns
    expected_keys = {'UserId', 'GameTitle', 'TopScore'}
    if not set(body.keys()).issubset(expected_keys):
        return False, 'Unexpected columns found.'
    
    return True, body