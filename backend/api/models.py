from django.db import models
from django.contrib.auth.models import User

class Category(models.Model):
    name = models.CharField(max_length=50, unique=True)
    icon_name = models.CharField(max_length=50, blank=True, default='coffee')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = 'Categories'
        ordering = ['id']

    def __str__(self):
        return self.name


class CoffeeItem(models.Model):
    name = models.CharField(max_length=100)
    category = models.ForeignKey(Category, related_name='coffees', on_delete=models.CASCADE)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=6, decimal_places=2)
    rating = models.FloatField(default=4.8)
    is_popular = models.BooleanField(default=False)
    image_asset = models.CharField(max_length=200, blank=True, default='assets/images/cappuccino.png')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['id']

    def __str__(self):
        return f"{self.name} (${self.price})"


class Order(models.Model):
    STATUS_CHOICES = (
        ('pending', 'Order Placed'),
        ('preparing', 'Preparing Your Coffee'),
        ('out_for_delivery', 'Out for Delivery'),
        ('delivered', 'Delivered'),
        ('cancelled', 'Cancelled'),
    )

    user = models.ForeignKey(User, related_name='orders', on_delete=models.SET_NULL, null=True, blank=True)
    order_number = models.CharField(max_length=20, unique=True)
    subtotal = models.DecimalField(max_digits=8, decimal_places=2)
    delivery_fee = models.DecimalField(max_digits=6, decimal_places=2, default=1.00)
    total = models.DecimalField(max_digits=8, decimal_places=2)
    status = models.CharField(max_length=30, choices=STATUS_CHOICES, default='out_for_delivery')
    delivery_address = models.CharField(max_length=255, default='221B Baker Street, London')
    payment_method = models.CharField(max_length=50, default='Cash on Delivery')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Order #{self.order_number} - ${self.total} ({self.status})"


class OrderItem(models.Model):
    order = models.ForeignKey(Order, related_name='items', on_delete=models.CASCADE)
    coffee = models.ForeignKey(CoffeeItem, on_delete=models.SET_NULL, null=True, blank=True)
    coffee_name = models.CharField(max_length=100)
    quantity = models.PositiveIntegerField(default=1)
    unit_price = models.DecimalField(max_digits=6, decimal_places=2)

    def __str__(self):
        return f"{self.quantity}x {self.coffee_name} (${self.unit_price})"

    @property
    def total_price(self):
        return self.quantity * self.unit_price


class Notification(models.Model):
    user = models.ForeignKey(User, related_name='notifications', on_delete=models.SET_NULL, null=True, blank=True)
    title = models.CharField(max_length=100)
    message = models.TextField()
    time_ago = models.CharField(max_length=20, default='Just now')
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.title}: {self.message[:30]}"


class UserProfile(models.Model):
    user = models.OneToOneField(User, related_name='profile', on_delete=models.CASCADE)
    full_name = models.CharField(max_length=150, default='Murad Demelash')
    default_address = models.CharField(max_length=255, default='221B Baker Street, London')
    phone = models.CharField(max_length=30, blank=True, default='')

    def __str__(self):
        return self.full_name
