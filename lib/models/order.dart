import 'cart_item.dart';

enum OrderStatus {
  pending,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime orderDate;
  final String dateFormatted;
  final OrderStatus status;
  final String address;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.items,
    required this.subtotal,
    this.deliveryFee = 1.00,
    required this.total,
    required this.orderDate,
    required this.dateFormatted,
    this.status = OrderStatus.delivered,
    this.address = '221B Baker Street, London',
    this.paymentMethod = 'Cash on Delivery',
  });
}

