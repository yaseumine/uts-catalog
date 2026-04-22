import 'package:catalog/core/services/dio_clients.dart';
import 'package:catalog/features/cart/data/models/checkout_model.dart';
import 'package:catalog/features/cart/data/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  @override
  Future<bool> processCheckout(CheckoutRequestModel data) async {
    try {
      // Endpoint yang BENAR sesuai kodingan Golang dosenmu
      final response = await DioClient.instance.post(
        '/orders/checkout',
        data: data.toJson(),
      );

      // Kalau berhasil, return true
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // Tangkap error buat dilempar ke Provider
      rethrow;
    }
  }
}
