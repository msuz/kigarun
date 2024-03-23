import json
import common # Lambda Layer で定義済みの共通処理

def lambda_handler(event, context):
    table = common.get_dynamodb_table()
    
    try:
        body = json.loads(event['body'])
        
        valid, response = common.validate_input(body)
        if not valid:
            return {'statusCode': 400, 'body': json.dumps({'message': response})}
        
        table.put_item(Item=response)
        
        return {'statusCode': 200, 'body': json.dumps({'message': 'Item added successfully to GameScores'})}
    
    except Exception as e:
        print(e)
        return {'statusCode': 500, 'body': json.dumps({'message': 'Error processing your request for GameScores'})}
