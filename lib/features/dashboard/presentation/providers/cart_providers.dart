import 'package:catalog/features/cart/data/models/cart_item_model.dart';
import 'package:catalog/features/cart/data/models/checkout_model.dart';
import 'package:catalog/features/dashboard/data/models/product_models.dart';
import 'package:catalog/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItemModel> _items = {};
  final CartRepositoryImpl _repository = CartRepositoryImpl();

  bool _isLoading = false;
  String? _errorMessage;

  Map<int, CartItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void addToCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItemModel(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach(
      (key, cartItem) => total += cartItem.product.price * cartItem.quantity,
    );
    return total;
  }

  int get totalItems {
    int count = 0;
    _items.forEach((key, cartItem) => count += cartItem.quantity);
    return count;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // ===== FUNGSI BARU UNTUK NEMBAK KE DATABASE GOLANG =====
  Future<bool> checkout({required String address, String notes = ''}) async {
    if (_items.isEmpty) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Bungkus data belanjaan sesuai format tabel order
      final requestData = CheckoutRequestModel(
        items: _items.values
            .map(
              (item) => CheckoutItemModel(
                productId: item.product.id,
                quantity: item.quantity,
                price: item.product.price,
              ),
            )
            .toList(),
        totalAmount: totalPrice,
        shippingAddress: address,
        notes: notes,
      );

      // 2. Kirim ke Golang
      final success = await _repository.processCheckout(requestData);

      if (success) {
        _items.clear(); // Bersihkan keranjang kalau masuk ke DB
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Gagal memproses pesanan di server');
      }
    } catch (e) {
      _errorMessage = 'Gagal checkout: Periksa koneksi internetmu';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
