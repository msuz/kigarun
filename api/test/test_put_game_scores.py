import unittest
import sys
import os

# テスト対象のLambda関数があるディレクトリ（一つ上のディレクトリ）をsys.pathに追加
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from get_message import lambda_handler

class TestLambdaFunction(unittest.TestCase):
    None # DynamoDBとの結合が必要となる部分は対象外

if __name__ == '__main__':
    unittest.main()