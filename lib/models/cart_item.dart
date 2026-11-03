import 'coffee_item.dart';

class CartItem {
  final CoffeeItem coffee;
  int quantity;

  CartItem({
    required this.coffee,
    this.quantity = 1,
  });

  double get totalPrice => coffee.price * quantity;
}

