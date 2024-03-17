import json
import boto3

# DynamoDB クライアントを初期化（グローバルスコープではなく関数内で初期化するように変更）
def get_dynamodb_table(table_name):
    dynamodb = boto3.resource('dynamodb')
    return dynamodb.Table(table_name)

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

def lambda_handler(event, context):
    table = get_dynamodb_table('GameScores')
    
    try:
        body = json.loads(event['body'])
        
        valid, response = validate_input(body)
        if not valid:
            return {'statusCode': 400, 'body': json.dumps({'message': response})}
        
        table.put_item(Item=response)
        
        return {'statusCode': 200, 'body': json.dumps({'message': 'Item added successfully to GameScores'})}
    
    except Exception as e:
        print(e)
        return {'statusCode': 500, 'body': json.dumps({'message': 'Error processing your request for GameScores'})}
