class CoffeeItem {
  final String id;
  final String name;
  final String category; // 'Coffee', 'Tea', 'Latte', 'Others'
  final String description;
  final double price;
  final String imageAsset;
  final double rating;
  final bool isPopular;

  const CoffeeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageAsset,
    this.rating = 4.8,
    this.isPopular = false,
  });
}

// Sample items matching the UI mockup
final List<CoffeeItem> dummyCoffeeItems = [
  const CoffeeItem(
    id: '1',
    name: 'Espresso',
    category: 'Coffee',
    description: 'Strong and bold',
    price: 3.00,
    imageAsset: 'assets/images/espresso.png',
    rating: 4.9,
    isPopular: false,
  ),
  const CoffeeItem(
    id: '2',
    name: 'Americano',
    category: 'Coffee',
    description: 'Pure coffee taste',
    price: 3.50,
    imageAsset: 'assets/images/americano.png',
    rating: 4.7,
    isPopular: false,
  ),
  const CoffeeItem(
    id: '3',
    name: 'Cappuccino',
    category: 'Coffee',
    description: 'Smooth & creamy',
    price: 4.50,
    imageAsset: 'assets/images/cappuccino.png',
    rating: 4.9,
    isPopular: true,
  ),
  const CoffeeItem(
    id: '4',
    name: 'Latte',
    category: 'Latte',
    description: 'Rich and silky',
    price: 4.50,
    imageAsset: 'assets/images/latte.png',
    rating: 4.8,
    isPopular: true,
  ),
  const CoffeeItem(
    id: '5',
    name: 'Mocha',
    category: 'Coffee',
    description: 'Coffee with chocolate',
    price: 5.00,
    imageAsset: 'assets/images/mocha.png',
    rating: 4.9,
    isPopular: true,
  ),
  const CoffeeItem(
    id: '6',
    name: 'Green Herbal Tea',
    category: 'Tea',
    description: 'Fresh & soothing aroma',
    price: 3.25,
    imageAsset: 'assets/images/tea.png',
    rating: 4.6,
    isPopular: false,
  ),
  const CoffeeItem(
    id: '7',
    name: 'Caramel Macchiato',
    category: 'Others',
    description: 'Sweet vanilla & espresso',
    price: 4.75,
    imageAsset: 'assets/images/banner_coffee.png',
    rating: 4.8,
    isPopular: true,
  ),
];

