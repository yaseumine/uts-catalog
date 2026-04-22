import 'package:catalog/features/cart/data/models/checkout_model.dart';

abstract class CartRepository {
  // Kontrak fungsi checkout yang harus ada di implementasi
  Future<bool> processCheckout(CheckoutRequestModel data);
}
