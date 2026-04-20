import 'package:catalog/core/constants/api_constrants.dart';
import 'package:catalog/core/services/dio_clients.dart';
import 'package:catalog/features/dashboard/data/models/product_models.dart';
import 'package:catalog/features/dashboard/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    final response = await DioClient.instance.get(
      ApiConstants.products,
      queryParameters: {'page': page, 'limit': limit, 'category': category},
    );

    final List<dynamic> data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await DioClient.instance.get(
      '${ApiConstants.products}/$id',
    );
    return ProductModel.fromJson(response.data['data']);
  }
}
