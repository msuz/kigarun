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

## put sample item

```
% python3 put_game_score_user123.py
```