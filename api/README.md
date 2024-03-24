# kigarun api

## Environment

* aws lambda function via api gateway
* runtime: python 3.12

## Unit Test

```
% cd /PATH/TO/KIGARUN/api/test
% python3 -m unittest
....
----------------------------------------------------------------------
Ran 4 tests in 0.000s

OK
```

## Deploy

```
% cd /PATH/TO/KIGARUN/api
% vi get_message.py
% zip get_message.zip get_message.py

% cd /PATH/TO/KIGARUN/infra
% terraform plan
% terraform apply
  Enter a value: yes
```

## Integration Test

```
% terraform apply

% api_id=$(aws apigateway get-rest-apis | jq -r '.items[] | select(.name=="KigarunAPI") | .id') && \
region=$(aws configure get region) && \
stage_name=$(aws apigateway get-stages --rest-api-id $api_id | jq -r '.item[0].stageName') && \
KIGARUN_API="https://${api_id}.execute-api.${region}.amazonaws.com/${stage_name}" && \
echo ${KIGARUN_API}
```

```
% curl -s -X GET "${KIGARUN_API}/message" | jq .
{
  "status": "ok",
  "message": "hello world"
}
```

CORS

```
% curl -s -i -X GET "${KIGARUN_API}/message" | grep access-control-allow
access-control-allow-origin: *
access-control-allow-headers: *
access-control-allow-methods: GET
```

```
% curl -s -X PUT ${KIGARUN_API}/game-scores \
  -H "Content-Type: application/json" \
  -d '{
    "UserId": "user123",
    "GameTitle": "Space Invaders",
    "TopScore": 9999
  }' \
  | jq .
{
  "message": "Item added successfully to GameScores"
}

% curl -s -X PUT ${KIGARUN_API}/game-scores \
  -H "Content-Type: application/json" \
  -d '{
    "UserId": "user123",
    "GameTitle": "Pac Man",
    "TopScore": 7777
  }' \
  | jq .
{
  "message": "Item added successfully to GameScores"
}

% curl -s -X PUT ${KIGARUN_API}/game-scores \
  -H "Content-Type: application/json" \
  -d '{
    "UserId": "user888",
    "GameTitle": "Space Invaders",
    "TopScore": 8888
  }' \
  | jq .
{
  "message": "Item added successfully to GameScores"
}
```

```
% curl -s -X GET "${KIGARUN_API}/game-scores" | jq .
[
  {
    "UserId": "user123",
    "GameTitle": "Pac Man",
    "TopScore": 7777
  },
  {
    "UserId": "user123",
    "GameTitle": "Space Invaders",
    "TopScore": 9999
  },
  {
    "UserId": "user888",
    "GameTitle": "Space Invaders",
    "TopScore": 8888
  }
]
```