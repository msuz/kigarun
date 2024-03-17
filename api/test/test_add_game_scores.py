import unittest
import sys
import os
import json

# テスト対象のLambda関数があるディレクトリ（一つ上のディレクトリ）をsys.pathに追加
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from add_game_scores import validate_input

# ここではバリデーションチェックの関数のみをテストする
# DynamoDBとの結合が必要となる部分対象外

class TestLambdaFunction(unittest.TestCase):
    def test_validate_input_success(self):
        body = {'UserId': 'user1', 'GameTitle': 'game1', 'TopScore': 100}
        valid, response = validate_input(body)
        self.assertTrue(valid)
        self.assertEqual(response, body)

    def test_validate_input_missing_user_id(self):
        body = {'GameTitle': 'game1', 'TopScore': 100}
        valid, response = validate_input(body)
        self.assertFalse(valid)
        self.assertIn('UserId is required', response)

    def test_validate_input_unexpected_column(self):
        body = {'UserId': 'user1', 'GameTitle': 'game1', 'TopScore': 100, 'ExtraColumn': 'value'}
        valid, response = validate_input(body)
        self.assertFalse(valid)
        self.assertIn('Unexpected columns found.', response)

if __name__ == '__main__':
    unittest.main()