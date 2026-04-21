import 'package:catalog/features/cart/data/models/cart_item_model.dart';
import 'package:catalog/features/dashboard/data/models/product_models.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  // Menyimpan daftar barang di keranjang. Key-nya adalah ID produk.
  final Map<int, CartItemModel> _items = {};

  Map<int, CartItemModel> get items => _items;

  // 1. Fitur Tambah Barang
  void addToCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      // Kalau barang udah ada, tambah jumlahnya (quantity)
      _items[product.id]!.quantity += 1;
    } else {
      // Kalau barang baru, masukkan ke keranjang
      _items[product.id] = CartItemModel(product: product);
    }
    notifyListeners(); // WAJIB ada sesuai soal UTS [cite: 2023]
  }

  // 2. Fitur Hapus Barang
  void removeFromCart(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Kurangi jumlah barang (opsional tapi bagus buat UI)
  void decreaseQuantity(int productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // 3. Fitur Total Harga [cite: 2012, 2016]
  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  // Fitur Total Item (buat badge di icon keranjang)
  int get totalItems {
    int count = 0;
    _items.forEach((key, cartItem) {
      count += cartItem.quantity;
    });
    return count;
  }

  // 4. Simulasi Checkout (Kosongkan keranjang setelah sukses) [cite: 2018]
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
