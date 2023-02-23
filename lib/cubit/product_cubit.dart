import 'package:bloc/bloc.dart';
import 'package:mc_challange/model/product.dart';
import 'package:mc_challange/service/product_service.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final _product = ProductService();

  ProductCubit() : super(ProductInitial());

  Future<void> getProducts({int? page}) async {
    emit(ProductLoading());
    try {
      final products = await _product.getProduct(page: page);
      final categories = await _product.getCategory();

      emit(ProductSuccess(products: products, categories: categories));
    } catch (e) {
      print(e);

      emit(ProductFailure(message: "Gagal mendapatkan data"));
    }
  }
}
