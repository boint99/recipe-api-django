"""
Database models.
"""

from django.db import models
from django.contrib.auth.models import (
    AbstractBaseUser,
    BaseUserManager,
    PermissionsMixin,
)


class UserManage(BaseUserManager):
    """Manage for user."""

    def create_user(self, email, password=None, **extra_field):
        """Create, save and retun a new user."""
        user = self.model(email=email)
        user.set_password(password, **extra_field)
        user.save(using=self._db)

        return user


class User(AbstractBaseUser):
    """User in the system"""

    email = models.EmailField(max_length=255, unique=True)
    password = models.CharField(max_length=255)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserManage()

    USERNAME_FIELD = "email"

# app/seting => đăng ký AUTH_USER_MODEL = 'core.User
