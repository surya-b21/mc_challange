import 'package:mc_challange/model/product.dart';
import 'package:mc_challange/service/dio_service.dart';

class ProductService {
  final _http = DioService().http;
  // final limit = {for (int i = 1; i <= 10; i++) i: i * 10};

  Future<List<Product>> getProduct(
      {String? search, String? category, int? skip}) async {
    String url = "/products";
    String query = "limit=10";
    if (category != null) {
      url = "$url/categories/$category";
    }
    if (search != null) {
      url = "$url/search";
      query = "q=$search&$query";
    }
    if (skip != null) {
      query = "$query&skip=$skip";
    }
    final api = await _http.get("$url?$query");

    List<Product> data = productFromJson(api.data["products"]);
    return data;
  }

  Future<List<String>> getCategory() async {
    final api = await _http.get("/products/categories");

    List<String> castingResponse(List<dynamic> resp) =>
        List.from(resp.map((e) => e as String));

    return castingResponse(api.data);
  }
}
