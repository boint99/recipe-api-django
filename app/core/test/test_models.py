"""
Test for models.
"""

from django.test import TestCase
from django.contrib.auth import get_user_model


class ModelTests(TestCase):
    """Test models."""
    def test_create_user_with_email_successfull(seft):
        """Test creating a user with an email is success."""
        email = "test@example.com"
        password = "test@example.com"
        user = get_user_model().objects.create_user(
            email=email,
            password=password,
        )

        seft.assertEqual(user.email, email)
        seft.assertTrue(user.check_password(password))

    def test_new_user_email_normalized(self):
        """Test email is normailize for new user"""
        simple_email = [
            ['test1@EXAMPLE.com', 'test1@example.com'],
            ['Test2@Example.com', 'Test2@example.com'],
            ['TEST3@EXAMPLE.COM', 'TEST3@example.com'],
            ['test4@example.COM', 'test4@example.com'],
        ]

        for email, excepted in simple_email:
            user = get_user_model().objects.create_user(email, "simple123")
            self.assertEqual(user.email, excepted)

    def test_new_email_without_email_raises_error(self):
        """Test that creating a new user without an email raise a valueError"""
        with self.assertRaises(ValueError):
            get_user_model().objects.create_user('', 'simple123')

    def Test_create_supperuser(self):
        """test creating a supperuser"""
        user = get_user_model().objects.create_superuser(
            'test@example.com',
            'test123',
        )
        self.assertTrue(user.is_superuser)
        self.assertTrue(user.is_staff)
