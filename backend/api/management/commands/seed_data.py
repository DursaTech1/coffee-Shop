from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.utils import timezone
import datetime
from api.models import Category, CoffeeItem, Order, OrderItem, Notification, UserProfile

class Command(BaseCommand):
    help = 'Seeds initial CoffeeHub data matching the app mockups'

    def handle(self, *args, **options):
        self.stdout.write('Seeding CoffeeHub database...')

        # 1. Categories
        cat_coffee, _ = Category.objects.get_or_create(name='Coffee', defaults={'icon_name': 'local_cafe'})
        cat_tea, _ = Category.objects.get_or_create(name='Tea', defaults={'icon_name': 'emoji_food_beverage'})
        cat_latte, _ = Category.objects.get_or_create(name='Latte', defaults={'icon_name': 'coffee'})
        cat_others, _ = Category.objects.get_or_create(name='Others', defaults={'icon_name': 'cake'})

        # 2. Coffee items
        coffees = [
            {
                'name': 'Espresso',
                'category': cat_coffee,
                'description': 'Strong and bold',
                'price': 3.00,
                'rating': 4.9,
                'is_popular': False,
                'image_asset': 'assets/images/espresso.png',
            },
            {
                'name': 'Americano',
                'category': cat_coffee,
                'description': 'Pure coffee taste',
                'price': 3.50,
                'rating': 4.7,
                'is_popular': False,
                'image_asset': 'assets/images/americano.png',
            },
            {
                'name': 'Cappuccino',
                'category': cat_coffee,
                'description': 'Smooth & creamy',
                'price': 4.50,
                'rating': 4.9,
                'is_popular': True,
                'image_asset': 'assets/images/cappuccino.png',
            },
            {
                'name': 'Latte',
                'category': cat_latte,
                'description': 'Rich and silky',
                'price': 4.50,
                'rating': 4.8,
                'is_popular': True,
                'image_asset': 'assets/images/latte.png',
            },
            {
                'name': 'Mocha',
                'category': cat_coffee,
                'description': 'Coffee with chocolate',
                'price': 5.00,
                'rating': 4.9,
                'is_popular': True,
                'image_asset': 'assets/images/mocha.png',
            },
            {
                'name': 'Green Herbal Tea',
                'category': cat_tea,
                'description': 'Fresh & soothing aroma',
                'price': 3.25,
                'rating': 4.6,
                'is_popular': False,
                'image_asset': 'assets/images/tea.png',
            },
            {
                'name': 'Caramel Macchiato',
                'category': cat_others,
                'description': 'Sweet vanilla & espresso',
                'price': 4.75,
                'rating': 4.8,
                'is_popular': True,
                'image_asset': 'assets/images/banner_coffee.png',
            },
        ]

        for c_data in coffees:
            CoffeeItem.objects.update_or_create(
                name=c_data['name'],
                defaults=c_data,
            )

        # 3. User & Profile
        user, created = User.objects.get_or_create(
            username='murad',
            defaults={'email': 'murad@gmail.com', 'first_name': 'Murad', 'last_name': 'Demelash'}
        )
        if created:
            user.set_password('password123')
            user.save()

        profile, _ = UserProfile.objects.get_or_create(
            user=user,
            defaults={
                'full_name': 'Murad Demelash',
                'default_address': '221B Baker Street, London',
                'phone': '+1 (555) 234-5678',
            }
        )

        # 4. Mockup Orders
        cap = CoffeeItem.objects.filter(name='Cappuccino').first()
        moc = CoffeeItem.objects.filter(name='Mocha').first()
        lat = CoffeeItem.objects.filter(name='Latte').first()

        sample_orders = [
            {
                'order_number': '1023',
                'subtotal': 4.50,
                'delivery_fee': 0.00,
                'total': 4.50,
                'status': 'delivered',
                'days_ago': 4,
                'coffee': cap,
            },
            {
                'order_number': '1022',
                'subtotal': 5.00,
                'delivery_fee': 0.00,
                'total': 5.00,
                'status': 'delivered',
                'days_ago': 9,
                'coffee': moc,
            },
            {
                'order_number': '1021',
                'subtotal': 4.50,
                'delivery_fee': 0.00,
                'total': 4.50,
                'status': 'delivered',
                'days_ago': 14,
                'coffee': lat,
            },
        ]

        for o_data in sample_orders:
            order, o_created = Order.objects.get_or_create(
                order_number=o_data['order_number'],
                defaults={
                    'user': user,
                    'subtotal': o_data['subtotal'],
                    'delivery_fee': o_data['delivery_fee'],
                    'total': o_data['total'],
                    'status': o_data['status'],
                    'delivery_address': '221B Baker Street, London',
                    'payment_method': 'Cash on Delivery',
                }
            )
            if o_created and o_data['coffee']:
                OrderItem.objects.create(
                    order=order,
                    coffee=o_data['coffee'],
                    coffee_name=o_data['coffee'].name,
                    quantity=1,
                    unit_price=o_data['coffee'].price,
                )
                # adjust date
                target_date = timezone.now() - datetime.timedelta(days=o_data['days_ago'])
                Order.objects.filter(id=order.id).update(created_at=target_date)

        # 5. Notifications
        notifications = [
            {
                'title': 'Order Delivered',
                'message': 'Your order #1024 has been delivered. Enjoy your coffee!',
                'time_ago': '2h',
            },
            {
                'title': 'Special Offer',
                'message': 'Special Offer! Get 20% OFF on all coffee.',
                'time_ago': '1d',
            },
            {
                'title': 'Seasonal Special',
                'message': 'New seasonal drink available. Try our Pumpkin Latte!',
                'time_ago': '2d',
            },
            {
                'title': 'Out for Delivery',
                'message': 'Your order is on the way',
                'time_ago': '3d',
            },
        ]

        for n_data in notifications:
            Notification.objects.get_or_create(
                message=n_data['message'],
                defaults={
                    'user': user,
                    'title': n_data['title'],
                    'time_ago': n_data['time_ago'],
                }
            )

        self.stdout.write(self.style.SUCCESS('Successfully seeded CoffeeHub data!'))

