import unittest
import sys
import os
import json

# テスト対象のLambda関数があるディレクトリ（一つ上のディレクトリ）をsys.pathに追加
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from get_message import lambda_handler

class TestGetMessageLambdaHandler(unittest.TestCase):
    def test_lambda_handler(self):
        """Lambda関数が期待通りのレスポンスを返すことをテストする"""
        expected_response = {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': '{"status": "ok", "message": "hello world"}'
        }
        
        # Lambda関数をテストするためのダミーのeventとcontextオブジェクトを渡します。
        result = lambda_handler({}, {})
        data = json.loads(result['body'])
        self.assertEqual(result, expected_response)
        self.assertEqual(data['status'], 'ok')
        self.assertEqual(data['message'], 'hello world')

if __name__ == '__main__':
    unittest.main()
