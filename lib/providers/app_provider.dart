import 'package:flutter/material.dart';
import '../models/coffee_item.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/notification_item.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    loadDataFromBackend();
  }

  // Theme state
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // User state
  String _userName = 'Murad Demelash';
  String _userEmail = 'murad@gmail.com';
  String get userName => _userName;
  String get userEmail => _userEmail;

  void updateUserProfile(String name, String email) {
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  Future<bool> loginUser(String email, String password) async {
    final result = await ApiService.login(email, password);
    if (result != null && result['user'] != null) {
      _userName = result['user']['name'] ?? _userName;
      _userEmail = result['user']['email'] ?? email;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> registerUser(String name, String email, String password) async {
    final result = await ApiService.register(name, email, password);
    if (result != null && result['user'] != null) {
      _userName = name;
      _userEmail = email;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Bottom navigation state
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // Categories & Filtering
  String _selectedCategory = 'Coffee';
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Available coffee menu items
  List<CoffeeItem> _coffeeCatalog = List.from(dummyCoffeeItems);
  List<CoffeeItem> get coffeeCatalog => _coffeeCatalog;

  List<CoffeeItem> get filteredMenu {
    return _coffeeCatalog.where((item) {
      final matchesCategory = _selectedCategory == 'All' ||
          item.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Cart state - initialized with mockup defaults (Cappuccino & Mocha)
  final List<CartItem> _cartItems = [
    CartItem(
      coffee: dummyCoffeeItems.firstWhere((i) => i.name == 'Cappuccino'),
      quantity: 1,
    ),
    CartItem(
      coffee: dummyCoffeeItems.firstWhere((i) => i.name == 'Mocha'),
      quantity: 1,
    ),
  ];
  List<CartItem> get cartItems => _cartItems;

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => _cartItems.isEmpty ? 0.0 : 1.00;
  double get total => subtotal + deliveryFee;

  void addToCart(CoffeeItem coffee) {
    final index = _cartItems.indexWhere((i) => i.coffee.id == coffee.id);
    if (index >= 0) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(CartItem(coffee: coffee, quantity: 1));
    }
    notifyListeners();
  }

  void incrementQuantity(CoffeeItem coffee) {
    final index = _cartItems.indexWhere((i) => i.coffee.id == coffee.id);
    if (index >= 0) {
      _cartItems[index].quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(CoffeeItem coffee) {
    final index = _cartItems.indexWhere((i) => i.coffee.id == coffee.id);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity -= 1;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(CoffeeItem coffee) {
    _cartItems.removeWhere((i) => i.coffee.id == coffee.id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Checkout info
  String _deliveryAddress = '221B Baker Street, London';
  String get deliveryAddress => _deliveryAddress;
  void setDeliveryAddress(String address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  String _paymentMethod = 'Cash on Delivery';
  String get paymentMethod => _paymentMethod;
  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  // Orders state - pre-populated with mockup history
  List<OrderModel> _orders = [
    OrderModel(
      id: '1023',
      items: [
        CartItem(
          coffee: dummyCoffeeItems.firstWhere((i) => i.name == 'Cappuccino'),
          quantity: 1,
        ),
      ],
      subtotal: 4.50,
      total: 4.50,
      orderDate: DateTime(2026, 10, 30),
      dateFormatted: 'Oct 30, 2026',
      status: OrderStatus.delivered,
    ),
    OrderModel(
      id: '1022',
      items: [
        CartItem(
          coffee: dummyCoffeeItems.firstWhere((i) => i.name == 'Mocha'),
          quantity: 1,
        ),
      ],
      subtotal: 5.00,
      total: 5.00,
      orderDate: DateTime(2026, 10, 25),
      dateFormatted: 'Oct 25, 2026',
      status: OrderStatus.delivered,
    ),
    OrderModel(
      id: '1021',
      items: [
        CartItem(
          coffee: dummyCoffeeItems.firstWhere((i) => i.name == 'Latte'),
          quantity: 1,
        ),
      ],
      subtotal: 4.50,
      total: 4.50,
      orderDate: DateTime(2026, 10, 20),
      dateFormatted: 'Oct 20, 2026',
      status: OrderStatus.delivered,
    ),
  ];
  List<OrderModel> get orders => _orders;

  OrderModel? _activeOrder;
  OrderModel? get activeOrder => _activeOrder;

  OrderModel placeOrder() {
    final currentSubtotal = subtotal;
    final currentDeliveryFee = deliveryFee;
    final currentTotal = total;
    final currentAddress = _deliveryAddress;
    final currentPayment = _paymentMethod;
    final currentItems = List<CartItem>.from(_cartItems);

    final localOrder = OrderModel(
      id: '${1024 + _orders.length}',
      items: currentItems,
      subtotal: currentSubtotal,
      deliveryFee: currentDeliveryFee,
      total: currentTotal,
      orderDate: DateTime.now(),
      dateFormatted: 'Nov 03, 2026',
      status: OrderStatus.outForDelivery,
      address: currentAddress,
      paymentMethod: currentPayment,
    );

    _orders.insert(0, localOrder);
    _activeOrder = localOrder;
    _cartItems.clear();
    notifyListeners();

    // Async sync to Django backend
    ApiService.createOrder(
      items: currentItems,
      subtotal: currentSubtotal,
      deliveryFee: currentDeliveryFee,
      total: currentTotal,
      address: currentAddress,
      paymentMethod: currentPayment,
    ).then((apiOrder) {
      if (apiOrder != null) {
        final index = _orders.indexOf(localOrder);
        if (index != -1) {
          _orders[index] = apiOrder;
          _activeOrder = apiOrder;
          notifyListeners();
        }
      }
    });

    return localOrder;
  }

  // Notifications
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Order Delivered',
      message: 'Your order #1024 has been delivered. Enjoy your coffee!',
      timeAgo: '2h',
    ),
    NotificationItem(
      id: '2',
      title: 'Special Offer!',
      message: 'Special Offer! Get 20% OFF on all coffee.',
      timeAgo: '1d',
    ),
    NotificationItem(
      id: '3',
      title: 'New Drink',
      message: 'New seasonal drink available. Try our Pumpkin Latte!',
      timeAgo: '2d',
    ),
    NotificationItem(
      id: '4',
      title: 'Order Status',
      message: 'Your order is on the way',
      timeAgo: '3d',
    ),
  ];
  List<NotificationItem> get notifications => _notifications;

  // Sync data from Django backend
  Future<void> loadDataFromBackend() async {
    try {
      final remoteCoffees = await ApiService.getCoffees();
      if (remoteCoffees != null && remoteCoffees.isNotEmpty) {
        _coffeeCatalog = remoteCoffees;
        notifyListeners();
      }

      final remoteOrders = await ApiService.getOrders();
      if (remoteOrders != null && remoteOrders.isNotEmpty) {
        _orders = remoteOrders;
        notifyListeners();
      }

      final remoteNotifs = await ApiService.getNotifications();
      if (remoteNotifs != null && remoteNotifs.isNotEmpty) {
        _notifications = remoteNotifs;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading data from Django backend: $e');
    }
  }
}
