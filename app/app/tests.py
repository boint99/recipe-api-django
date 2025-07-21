"""
Simple test case
"""
from django.test import TestCase

from app import calc


class testCase(TestCase):
    """Test  the calc number"""

    def test_add_number(self):
        "test adding model"
        response = calc.add(5, 6)
        self.assertEqual(response, 11)

    def test_subStract(self):
        "test subStract model"
        res = calc.subStract(5, 6)
        self.assertEqual(res, -1)
