part of 'product_cubit.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<Product> products;
  final List<String> categories;
  bool? loading;

  ProductSuccess({
    required this.products,
    required this.categories,
    this.loading,
  });

  ProductSuccess.loading(
      {required List<Product> products,
      required List<String> categories,
      required bool loading})
      : this(products: products, categories: categories, loading: loading);

  ProductSuccess copyWith({required List<Product> products}) {
    return ProductSuccess(
        products: this.products + products,
        categories: categories,
        loading: false);
  }
}

class ProductFailure extends ProductState {
  final String message;

  ProductFailure({required this.message});
}
