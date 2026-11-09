import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/api_response.dart';
import '../../core/master_object.dart';
import '../../data/network_datasource/network_client.dart';

class ApiRepository<T extends MasterObject<T>> {
  final NetworkClient networkClient;
  final String baseUrl;

  ApiRepository({required this.networkClient, String? baseUrl})
    : baseUrl = baseUrl ?? const String.fromEnvironment('API_BASE_URL');

  ApiResponse<R> handleResponse<R>(
    http.Response response,
    R Function(dynamic) parser, {
    bool isList = false,
  }) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final dynamic decodedJson = json.decode(response.body);
          return ApiResponse<R>(
            success: true,
            data: parser(decodedJson),
            statusCode: response.statusCode,
          );
        } else {
          return ApiResponse(
            success: true,
            data: parser({}),
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == 404) {
        return ApiResponse(
          success: false,
          message: "Requested resource not found.",
          statusCode: response.statusCode,
        );
      } else {
        var errorMessage = json.decode(response.body);
        if (response.statusCode == 500) {
          errorMessage['message'] =
              "Server error occurred. Please try again later.";
        }

        return ApiResponse(
          success: false,
          message: errorMessage['message'],
          statusCode: response.statusCode,
        );
      }
    } on FormatException catch (e) {
      return ApiResponse(
        success: false,
        message: 'Data format error: $e',
        statusCode: response.statusCode,
      );
    } on SocketException {
      return ApiResponse(
        success: false,
        message: "No Internet",
        statusCode: 503,
      );
    } on http.ClientException catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network request failed: ${e.message}',
        statusCode: 503,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected parsing error occurred: $e',
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse<T>> get<T>(
    String endPoint,
    T Function(dynamic) parser, {
    Map<String, dynamic>? queryParams,
    bool isList = false,
  }) async {
    try {
      final Map<String, String>? stringParams = queryParams?.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      return _handleAuthenticatedRequest<T>(
        () async => networkClient.get(
          Uri.parse('$baseUrl$endPoint').replace(queryParameters: stringParams),
        ),
        parser,
      );
    } catch (e) {
      return ApiResponse(success: false, message: "Network error: $e");
    }
  }

  Future<ApiResponse<TResponse>> post<TRequest, TResponse>(
    String endpoint,
    TRequest? data,
    TResponse Function(dynamic) parser,
  ) async {
    try {
      return _handleAuthenticatedRequest<TResponse>(
        () async => networkClient.post(
          Uri.parse('$baseUrl$endpoint'),
          body: json.encode((data as dynamic).toMap(data)),
        ),
        parser,
      );
    } catch (e) {
      return ApiResponse(success: false, message: "Network error: $e");
    }
  }

  Future<ApiResponse<TResponse>> postWithoutBody<TRequest, TResponse>(
    String endpoint,
    TRequest data,
    TResponse Function(dynamic) parser,
  ) async {
    try {
      return _handleAuthenticatedRequest<TResponse>(
        () async => networkClient.post(Uri.parse('$baseUrl$endpoint')),
        parser,
      );
    } catch (e) {
      return ApiResponse(success: false, message: "Network error: $e");
    }
  }

  Future<ApiResponse<TResponse>> put<TRequest, TResponse>(
    String endpoint,
    String id,
    TRequest data,
    TResponse Function(dynamic) parser,
  ) async {
    try {
      return _handleAuthenticatedRequest<TResponse>(
        () async => networkClient.put(
          Uri.parse('$baseUrl/$endpoint/$id'),
          body: json.encode((data as dynamic).toMap(data)),
        ),
        parser,
      );
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: $e');
    }
  }

  Future<ApiResponse<T>> delete(
    String endpoint,
    String id,
    T Function(dynamic) parser,
  ) async {
    try {
      return _handleAuthenticatedRequest<T>(
        () async => networkClient.delete(Uri.parse('$baseUrl$endpoint/$id')),
        parser,
      );
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: $e');
    }
  }

  Future<ApiResponse<TResponse>> postMultipart<TResponse>(
    String endpoint,
    Map<String, dynamic> fields,
    File file,
    String fieldName,
    TResponse Function(dynamic) parser,
  ) async {
    try {
      final fullUri = Uri.parse('$baseUrl$endpoint');

      Map<String, String> stringFields = fields.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      final String fileName = file.path.split('/').last;
      final extension = file.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

      final multipartFile = await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        filename: fileName,
        contentType: http.MediaType.parse(mimeType),
      );
      final response = await networkClient.postMultipart(fullUri, [
        multipartFile,
      ], stringFields);
      return handleResponse<TResponse>(response, parser);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Multipart Upload Error: $e',
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse<TResponse>> putMultipart<TResponse>(
    String endpoint,
    Map<String, dynamic> fields,
    File file,
    String fieldName,
    TResponse Function(dynamic) parser,
  ) async {
    try {
      final fullUri = Uri.parse('$baseUrl$endpoint');

      Map<String, String> stringFields = fields.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      final String fileName = file.path.split('/').last;
      final extension = file.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

      final multipartFile = await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        filename: fileName,
        contentType: http.MediaType.parse(mimeType),
      );
      final response = await networkClient.putMultipart(fullUri, [
        multipartFile,
      ], stringFields);
      return handleResponse<TResponse>(response, parser);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Multipart Upload Error: $e',
        statusCode: 500,
      );
    }
  }

  void dispose() {
    networkClient.dispose();
  }

  Future<ApiResponse<TResponse>> _handleAuthenticatedRequest<TResponse>(
    Future<http.Response> Function() requestFunction,
    TResponse Function(dynamic) parser,
  ) async {
    try {
      http.Response response = await requestFunction();

      return handleResponse<TResponse>(response, parser);
    } on SocketException catch (e) {
      return ApiResponse(success: false, message: e.message, statusCode: 503);
    } on TimeoutException {
      return ApiResponse(
        success: false,
        message: "Request time out, please wait.",
        statusCode: 408,
      );
    } on http.ClientException catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network request failed: ${e.message}',
        statusCode: 503,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected parsing error occurred: $e',
        statusCode: 500,
      );
    }
  }
}
