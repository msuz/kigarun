import json
import common # Lambda Layer で定義済みの共通処理

def lambda_handler(event, context):
    table = common.get_dynamodb_table()  # テーブル取得
    
    # DynamoDBテーブル全スキャン
    response = table.scan()
    
    # scan結果をJSON形式でレスポンス
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(response['Items'], default=common.convert_dynamo2json_default)
    }
