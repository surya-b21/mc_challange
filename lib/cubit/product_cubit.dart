import 'package:bloc/bloc.dart';
import 'package:mc_challange/model/product.dart';
import 'package:mc_challange/service/product_service.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final _product = ProductService();

  ProductCubit() : super(ProductInitial());

  Future<void> getProducts() async {
    emit(ProductLoading());
    try {
      final products = await _product.getProduct();
      final categories = await _product.getCategory();

      emit(ProductSuccess(
          products: products, categories: categories, loading: false));
    } catch (e) {
      print(e);

      emit(ProductFailure(message: "Gagal mendapatkan data"));
    }
  }

  Future<void> getMoreProducts() async {
    ProductSuccess ps = state as ProductSuccess;
    emit(ProductSuccess.loading(
      products: ps.products,
      categories: ps.categories,
      loading: true,
    ));

    try {
      final products = await _product.getProduct(skip: ps.products.length);
      emit(ps.copyWith(products: products));
    } catch (e) {
      print(e);

      emit(ProductFailure(message: "Gagal mendapatkan data"));
    }
  }
}
