# kigarun db

## list tables

```
% aws dynamodb list-tables
{
    "TableNames": [
        "GameScores"
    ]
}

% aws dynamodb describe-table --table-name GameScores | jq .Table.AttributeDefinitions
[
  {
    "AttributeName": "GameTitle",
    "AttributeType": "S"
  },
  {
    "AttributeName": "TopScore",
    "AttributeType": "N"
  },
  {
    "AttributeName": "UserId",
    "AttributeType": "S"
  }
]
```

## awscli

### put

```
% aws dynamodb put-item \
    --table-name GameScores \
    --item '{
        "UserId": {"S": "user123"},
        "GameTitle": {"S": "Space Invaders"},
        "TopScore": {"N": "9999"}
    }'
```

## get

```
% aws dynamodb query \   
    --table-name GameScores \
    --key-condition-expression "UserId = :userId" \
    --expression-attribute-values '{":userId": {"S": "user123"}}'
{
    "Items": [
        {
            "UserId": {
                "S": "user123"
            },
            "GameTitle": {
                "S": "Space Invaders"
            },
            "TopScore": {
                "N": "9999"
            }
        }
    ],
    "Count": 1,
    "ScannedCount": 1,
    "ConsumedCapacity": null
}
```

## python script

```
% cd put_sample_item/
% python3 put_game_score_user123.py
{
    "ResponseMetadata": {
        "RequestId": "SH7GQAD8OL5OQIR3E491KGSKCVVV4KQNSO5AEMVJF66Q9ASUAAJG",
        "HTTPStatusCode": 200,
        "HTTPHeaders": {
            "server": "Server",
            "date": "Sat, 23 Mar 2024 08:57:27 GMT",
            "content-type": "application/x-amz-json-1.0",
            "content-length": "2",
            "connection": "keep-alive",
            "x-amzn-requestid": "SH7GQAD8OL5OQIR3E491KGSKCVVV4KQNSO5AEMVJF66Q9ASUAAJG",
            "x-amz-crc32": "2745614147"
        },
        "RetryAttempts": 0
    }
}
```
