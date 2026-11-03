from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Category, CoffeeItem, Order, OrderItem, Notification, UserProfile

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name', 'icon_name']


class CoffeeItemSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = CoffeeItem
        fields = [
            'id',
            'name',
            'category',
            'category_name',
            'description',
            'price',
            'rating',
            'is_popular',
            'image_asset',
        ]


class OrderItemSerializer(serializers.ModelSerializer):
    total_price = serializers.DecimalField(max_digits=8, decimal_places=2, read_only=True)

    class Meta:
        model = OrderItem
        fields = ['id', 'coffee', 'coffee_name', 'quantity', 'unit_price', 'total_price']


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, required=False)
    date_formatted = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = [
            'id',
            'order_number',
            'subtotal',
            'delivery_fee',
            'total',
            'status',
            'delivery_address',
            'payment_method',
            'created_at',
            'date_formatted',
            'items',
        ]
        read_only_fields = ['order_number', 'created_at']

    def get_date_formatted(self, obj):
        return obj.created_at.strftime('%b %d, %Y')

    def create(self, validated_data):
        items_data = self.context.get('request').data.get('items', [])
        import uuid
        order_number = str(uuid.uuid4().int)[:5]
        order = Order.objects.create(order_number=order_number, **validated_data)

        for item_data in items_data:
            coffee_id = item_data.get('coffee_id')
            coffee = CoffeeItem.objects.filter(id=coffee_id).first() if coffee_id else None
            OrderItem.objects.create(
                order=order,
                coffee=coffee,
                coffee_name=item_data.get('coffee_name', coffee.name if coffee else 'Coffee Item'),
                quantity=item_data.get('quantity', 1),
                unit_price=item_data.get('unit_price', coffee.price if coffee else 4.50),
            )
        return order


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ['id', 'title', 'message', 'time_ago', 'is_read', 'created_at']


class UserProfileSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(source='user.email', read_only=True)
    username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = UserProfile
        fields = ['full_name', 'email', 'username', 'default_address', 'phone']


class RegisterSerializer(serializers.Serializer):
    full_name = serializers.CharField(max_length=150)
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("A user with this email already exists.")
        return value

    def create(self, validated_data):
        email = validated_data['email']
        username = email.split('@')[0]
        user = User.objects.create_user(
            username=username,
            email=email,
            password=validated_data['password']
        )
        UserProfile.objects.create(
            user=user,
            full_name=validated_data.get('full_name', username),
        )
        return user


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

