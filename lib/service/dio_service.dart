import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  Dio _dio() {
    final options = BaseOptions(
      baseUrl: "https://dummyjson.com",
      connectTimeout: 3000,
    );

    final logger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      compact: true,
    );

    var dio = Dio(options);

    dio.interceptors.add(logger);

    return dio;
  }

  Dio get http => _dio();
}
