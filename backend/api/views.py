from rest_framework import status, views, viewsets
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.db.models import Q

from .models import Category, CoffeeItem, Order, Notification, UserProfile
from .serializers import (
    CategorySerializer,
    CoffeeItemSerializer,
    OrderSerializer,
    NotificationSerializer,
    UserProfileSerializer,
    RegisterSerializer,
    LoginSerializer,
)

class RegisterAPIView(views.APIView):
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            token, _ = Token.objects.get_or_create(user=user)
            profile = getattr(user, 'profile', None)
            return Response({
                'token': token.key,
                'user': {
                    'id': user.id,
                    'name': profile.full_name if profile else user.username,
                    'email': user.email,
                }
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LoginAPIView(views.APIView):
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            password = serializer.validated_data['password']

            user = User.objects.filter(email=email).first()
            if not user:
                # Fallback to username
                user = User.objects.filter(username=email).first()

            if user and user.check_password(password):
                token, _ = Token.objects.get_or_create(user=user)
                profile = getattr(user, 'profile', None)
                return Response({
                    'token': token.key,
                    'user': {
                        'id': user.id,
                        'name': profile.full_name if profile else user.username,
                        'email': user.email,
                    }
                })
            return Response({'error': 'Invalid email or password.'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserProfileAPIView(views.APIView):
    def get(self, request):
        user = request.user if request.user.is_authenticated else User.objects.first()
        if not user:
            return Response({'full_name': 'Murad Demelash', 'email': 'murad@gmail.com'})
        profile, _ = UserProfile.objects.get_or_create(user=user)
        return Response(UserProfileSerializer(profile).data)

    def put(self, request):
        user = request.user if request.user.is_authenticated else User.objects.first()
        if not user:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        profile, _ = UserProfile.objects.get_or_create(user=user)
        serializer = UserProfileSerializer(profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CategoryListAPIView(views.APIView):
    def get(self, request):
        categories = Category.objects.all()
        return Response(CategorySerializer(categories, many=True).data)


class CoffeeItemListAPIView(views.APIView):
    def get(self, request):
        queryset = CoffeeItem.objects.all()

        category = request.query_params.get('category')
        if category and category.lower() != 'all':
            queryset = queryset.filter(category__name__iexact=category)

        search = request.query_params.get('search')
        if search:
            queryset = queryset.filter(
                Q(name__icontains=search) | Q(description__icontains=search)
            )

        popular = request.query_params.get('popular')
        if popular:
            queryset = queryset.filter(is_popular=True)

        return Response(CoffeeItemSerializer(queryset, many=True).data)


class OrderListCreateAPIView(views.APIView):
    def get(self, request):
        orders = Order.objects.all()
        status_filter = request.query_params.get('status')
        if status_filter and status_filter.lower() != 'all':
            if status_filter.lower() == 'pending':
                orders = orders.filter(status__in=['pending', 'preparing', 'out_for_delivery'])
            else:
                orders = orders.filter(status__iexact=status_filter)

        return Response(OrderSerializer(orders, many=True).data)

    def post(self, request):
        serializer = OrderSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            user = request.user if request.user.is_authenticated else None
            order = serializer.save(user=user)
            return Response(OrderSerializer(order).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class OrderDetailAPIView(views.APIView):
    def get(self, request, pk):
        try:
            order = Order.objects.get(pk=pk)
            return Response(OrderSerializer(order).data)
        except Order.DoesNotExist:
            return Response({'error': 'Order not found'}, status=status.HTTP_404_NOT_FOUND)


class NotificationListAPIView(views.APIView):
    def get(self, request):
        notifications = Notification.objects.all()
        return Response(NotificationSerializer(notifications, many=True).data)
