import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/coffee_item.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/notification_item.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000/api';
      }
    } catch (_) {}
    return 'http://127.0.0.1:8000/api';
  }

  static String? authToken;

  // 1. Authentication
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        authToken = data['token'];
        return data;
      }
    } catch (e) {
      debugPrint('ApiService.login fallback: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> register(
      String fullName, String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'full_name': fullName,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        authToken = data['token'];
        return data;
      }
    } catch (e) {
      debugPrint('ApiService.register fallback: $e');
    }
    return null;
  }

  // 2. Coffees & Menu
  static Future<List<CoffeeItem>?> getCoffees({String? category, String? search}) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'All') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse('$baseUrl/coffees/').replace(queryParameters: queryParams);
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        return list.map((json) {
          return CoffeeItem(
            id: json['id'].toString(),
            name: json['name'],
            category: json['category_name'] ?? 'Coffee',
            description: json['description'] ?? '',
            price: double.tryParse(json['price'].toString()) ?? 4.00,
            imageAsset: json['image_asset'] ?? 'assets/images/cappuccino.png',
            rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
            isPopular: json['is_popular'] ?? false,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('ApiService.getCoffees fallback: $e');
    }
    return null;
  }

  // 3. Orders
  static Future<List<OrderModel>?> getOrders() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/orders/'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        return list.map((json) {
          final itemsList = (json['items'] as List? ?? []).map((i) {
            return CartItem(
              coffee: CoffeeItem(
                id: (i['coffee'] ?? 1).toString(),
                name: i['coffee_name'] ?? 'Coffee',
                category: 'Coffee',
                description: '',
                price: double.tryParse(i['unit_price'].toString()) ?? 4.50,
                imageAsset: 'assets/images/cappuccino.png',
              ),
              quantity: i['quantity'] ?? 1,
            );
          }).toList();

          OrderStatus status = OrderStatus.delivered;
          final statusStr = json['status']?.toString().toLowerCase() ?? '';
          if (statusStr == 'pending') status = OrderStatus.pending;
          if (statusStr == 'preparing') status = OrderStatus.preparing;
          if (statusStr == 'out_for_delivery') status = OrderStatus.outForDelivery;
          if (statusStr == 'cancelled') status = OrderStatus.cancelled;

          return OrderModel(
            id: json['order_number']?.toString() ?? json['id'].toString(),
            items: itemsList,
            subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
            deliveryFee: double.tryParse(json['delivery_fee'].toString()) ?? 1.0,
            total: double.tryParse(json['total'].toString()) ?? 0.0,
            orderDate: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
            dateFormatted: json['date_formatted'] ?? 'Today',
            status: status,
            address: json['delivery_address'] ?? '221B Baker Street, London',
            paymentMethod: json['payment_method'] ?? 'Cash on Delivery',
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('ApiService.getOrders fallback: $e');
    }
    return null;
  }

  static Future<OrderModel?> createOrder({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String address,
    required String paymentMethod,
  }) async {
    try {
      final payload = {
        'subtotal': subtotal.toStringAsFixed(2),
        'delivery_fee': deliveryFee.toStringAsFixed(2),
        'total': total.toStringAsFixed(2),
        'delivery_address': address,
        'payment_method': paymentMethod,
        'status': 'out_for_delivery',
        'items': items.map((item) {
          return {
            'coffee_id': int.tryParse(item.coffee.id),
            'coffee_name': item.coffee.name,
            'quantity': item.quantity,
            'unit_price': item.coffee.price.toStringAsFixed(2),
          };
        }).toList(),
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/orders/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return OrderModel(
          id: json['order_number']?.toString() ?? json['id'].toString(),
          items: List.from(items),
          subtotal: subtotal,
          deliveryFee: deliveryFee,
          total: total,
          orderDate: DateTime.now(),
          dateFormatted: json['date_formatted'] ?? 'Nov 03, 2026',
          status: OrderStatus.outForDelivery,
          address: address,
          paymentMethod: paymentMethod,
        );
      }
    } catch (e) {
      debugPrint('ApiService.createOrder fallback: $e');
    }
    return null;
  }

  // 4. Notifications
  static Future<List<NotificationItem>?> getNotifications() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/notifications/'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        return list.map((json) {
          return NotificationItem(
            id: json['id'].toString(),
            title: json['title'] ?? 'Notification',
            message: json['message'] ?? '',
            timeAgo: json['time_ago'] ?? 'Just now',
            isRead: json['is_read'] ?? false,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('ApiService.getNotifications fallback: $e');
    }
    return null;
  }
}

