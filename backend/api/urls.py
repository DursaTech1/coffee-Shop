from django.urls import path
from .views import (
    RegisterAPIView,
    LoginAPIView,
    UserProfileAPIView,
    CategoryListAPIView,
    CoffeeItemListAPIView,
    OrderListCreateAPIView,
    OrderDetailAPIView,
    NotificationListAPIView,
)

urlpatterns = [
    # Auth & Profile
    path('auth/register/', RegisterAPIView.as_view(), name='register'),
    path('auth/login/', LoginAPIView.as_view(), name='login'),
    path('auth/profile/', UserProfileAPIView.as_view(), name='profile'),

    # Menu & Categories
    path('categories/', CategoryListAPIView.as_view(), name='categories'),
    path('coffees/', CoffeeItemListAPIView.as_view(), name='coffees'),

    # Orders & Tracking
    path('orders/', OrderListCreateAPIView.as_view(), name='orders'),
    path('orders/<int:pk>/', OrderDetailAPIView.as_view(), name='order-detail'),

    # Notifications
    path('notifications/', NotificationListAPIView.as_view(), name='notifications'),
]

