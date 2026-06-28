import 'package:clan_architecture/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static String baseUrl = "https://codingarabic.online/api/";
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post('login', data: request.toJson());

      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception(
          response.data['message']?.toString() ?? 'something went wrong',
        );
      }

      final authResponse = AuthResponseModel.fromJson(data);
      await _saveToken(authResponse.token);
      return authResponse;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dio.post('register', data: request.toJson());

      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception(
          response.data['message']?.toString() ?? 'something went wrong',
        );
      }

      final authResponse = AuthResponseModel.fromJson(data);
      await _saveToken(authResponse.token);
      return authResponse;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Never handleDioError(DioException e) {
    if (e.response != null) {
      print('Server Error: ${e.response?.data}');
      final errors = e.response?.data?['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstField = errors.values.first;
        final firstMsg = firstField is List && firstField.isNotEmpty
            ? firstField.first.toString()
            : firstField.toString();
        throw Exception(firstMsg);
      }
      final errorMessage =
          e.response?.data?['message']?.toString() ?? 'something went wrong';
      throw Exception(errorMessage);
    } else {
      throw Exception('Connection Error');
    }
  }
}
