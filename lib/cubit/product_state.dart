part of 'product_cubit.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<Product> products;
  final List<String> categories;

  ProductSuccess({required this.products, required this.categories});
}

class ProductFailure extends ProductState {
  final String message;

  ProductFailure({required this.message});
}
