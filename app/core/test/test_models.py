"""
Test for models.
"""

from django.test import TestCase
from django.contrib.auth import get_user_model


class ModelTests(TestCase):
    """Test models."""
    def test_create_user_with_email_successfull(seft):
        """Test creating a user with an email is success."""
        email = "test@local.com"
        password = "test@local.com"
        user = get_user_model().objects.create_user(
            email=email,
            password=password,
        )

        seft.assertEqual(user.email, email)
        seft.assertTrue(user.check_password(password))
