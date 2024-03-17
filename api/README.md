# kigarun api

## Environment

* aws lambda function via api gateway
* runtime: python 3.12

## Unit Test

```
% cd /PATH/TO/KIGARUN/api/test
% python3 -m unittest                    
.
----------------------------------------------------------------------
Ran 1 test in 0.000s

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
(TBD)
```