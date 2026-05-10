import 'dart:typed_data';

import 'package:coffee_repository/coffee_repository.dart';

class LocalCoffeeRepo implements CoffeeRepo {
  const LocalCoffeeRepo();

  static List<Coffee> get bundledMenu => List<Coffee>.unmodifiable(_coffeeMenu);

  @override
  Future<List<Coffee>> getCoffees() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return bundledMenu;
  }

  @override
  Future<void> createCoffee(Coffee coffee) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final normalizedCoffee = coffee.copyWith(
      coffeeId: coffee.coffeeId.trim().isNotEmpty
          ? coffee.coffeeId.trim()
          : 'local-${DateTime.now().millisecondsSinceEpoch}',
      sortOrder: coffee.sortOrder > 0
          ? coffee.sortOrder
          : DateTime.now().millisecondsSinceEpoch,
    );

    _coffeeMenu.removeWhere(
      (existingCoffee) => existingCoffee.coffeeId == normalizedCoffee.coffeeId,
    );
    _coffeeMenu.insert(0, normalizedCoffee);
  }

  @override
  Future<String> uploadCoffeeImage(Uint8List file, String fileName) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=900&q=80';
  }
}

final List<Coffee> _coffeeMenu = <Coffee>[
  const Coffee(
    sortOrder: 1,
    coffeeId: 'phin-sua-da-signature',
    picture: 'assets/coffee/velvet_latte.jpg',
    name: 'Phin Sữa Đá Signature',
    tagline: 'Robusta đậm vị, sữa đặc và lớp foam mềm.',
    description:
        'Ly phin chủ lực với nền Robusta Việt Nam, sữa đặc cân bằng và lớp kem sữa nhẹ, giữ chất cà phê rõ ràng nhưng vẫn mềm và dễ uống.',
    category: 'Phin Việt',
    origin: 'Cầu Đất x Đắk Lắk',
    roastLevel: 'Đậm vừa',
    intensity: 4,
    brewMinutes: 5,
    volumeMl: 320,
    rating: 4.9,
    price: 49000,
    discount: 10,
    tastingNotes: <String>['Cacao', 'Caramel', 'Sữa đặc'],
    macros: Macros(
      calories: 210,
      proteins: 8,
      fat: 8,
      carbs: 23,
    ),
  ),
  const Coffee(
    sortOrder: 2,
    coffeeId: 'mocha-da-xay',
    picture: 'assets/coffee/midnight_mocha.jpg',
    name: 'Mocha Đá Xay',
    tagline: 'Socola đậm, espresso và kem sữa đầy vị.',
    description:
        'Mocha đá xay dành cho những khách muốn vị ngọt gọn gàng. Nền espresso được giữ lại để cốc vẫn ra chất cà phê thay vì chỉ như món tráng miệng.',
    category: 'Đá Xay',
    origin: 'Đà Lạt Arabica',
    roastLevel: 'Đậm',
    intensity: 4,
    brewMinutes: 5,
    volumeMl: 360,
    rating: 4.9,
    price: 69000,
    discount: 15,
    tastingNotes: <String>['Socola đen', 'Hạt rang', 'Kem sữa'],
    macros: Macros(
      calories: 280,
      proteins: 7,
      fat: 11,
      carbs: 30,
    ),
  ),
  const Coffee(
    sortOrder: 3,
    coffeeId: 'cold-brew-cam',
    picture: 'assets/coffee/citrus_pour_over.jpg',
    name: 'Cold Brew Cam',
    tagline: 'Làn sóng citrus nhẹ, hậu vị sạch và mát.',
    description:
        'Cold brew ngâm lạnh được làm sáng vị với cam vàng, giữ độ êm và ít chua. Hương vị hợp với khách thích món tinh tế, nhanh gọn và dễ uống suốt ngày.',
    category: 'Cold Brew',
    origin: 'Lâm Đồng Arabica',
    roastLevel: 'Nhẹ vừa',
    intensity: 3,
    brewMinutes: 6,
    volumeMl: 320,
    rating: 4.8,
    price: 59000,
    discount: 8,
    tastingNotes: <String>['Cam vàng', 'Mật ong', 'Vỏ quýt'],
    macros: Macros(
      calories: 45,
      proteins: 1,
      fat: 0,
      carbs: 10,
    ),
  ),
  const Coffee(
    sortOrder: 4,
    coffeeId: 'espresso-sua-dua',
    picture: 'assets/coffee/maple_shaken_espresso.jpg',
    name: 'Espresso Sữa Dừa',
    tagline: 'Espresso lắc lạnh cùng sữa dừa thanh và thơm.',
    description:
        'Ly signature theo hướng hiện đại, kết hợp espresso rang đậm với sữa dừa và đá lắc. Tổng thể mát, thơm, có độ béo vừa đủ và rất hợp cho bữa sáng.',
    category: 'Đá Signature',
    origin: 'Đắk Lắk Robusta',
    roastLevel: 'Đậm vừa',
    intensity: 4,
    brewMinutes: 3,
    volumeMl: 280,
    rating: 4.8,
    price: 65000,
    discount: 12,
    tastingNotes: <String>['Sữa dừa', 'Toffee', 'Espresso rang đậm'],
    macros: Macros(
      calories: 150,
      proteins: 3,
      fat: 4,
      carbs: 18,
    ),
  ),
  const Coffee(
    sortOrder: 5,
    coffeeId: 'cold-brew-truyen-thong',
    picture: 'assets/coffee/house_cold_brew.jpg',
    name: 'Cold Brew Truyền Thống',
    tagline: 'Chậm ngâm 16 giờ, ít acid và đủ lực tỉnh táo.',
    description:
        'Cold brew truyền thống được ngâm chậm để giữ vị sạch, ít gắt và vẫn đầy năng lượng. Ly này phù hợp cho khách thích cà phê đen theo cách hiện đại hơn.',
    category: 'Cold Brew',
    origin: 'Kenya AA',
    roastLevel: 'Vừa',
    intensity: 5,
    brewMinutes: 8,
    volumeMl: 330,
    rating: 4.6,
    price: 52000,
    discount: 0,
    tastingNotes: <String>['Cacao nibs', 'Đường nâu', 'Mặn khô'],
    macros: Macros(
      calories: 15,
      proteins: 1,
      fat: 0,
      carbs: 3,
    ),
  ),
];
