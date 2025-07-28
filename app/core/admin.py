"""
Django admin custommization.
"""
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.translation import gettext_lazy as _

from core import models


class UserAdmin(BaseUserAdmin):
    """Define the admin pages for users."""
    ordering = ['id']
    list_display = ['email', 'name']
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        (_('permissions'), {
            'fields': (
                'name',
                'is_active',
                'is_staff',
                'is_superuser',
            )
        }),
        (_('Important dates'), {'fields': ('last_login',)}),
    )
    readonly_fields = ['last_login']
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': (
                'password1',
                'password2',
                'name',
                'is_superuser',
                'is_staff',
            )
        }),
    )


admin.site.register(models.User, UserAdmin)
