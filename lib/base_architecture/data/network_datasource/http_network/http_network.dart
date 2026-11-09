import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

import '../network_client.dart';
import 'logging_interceptor.dart';

class HttpNetworkClient implements NetworkClient {
  late final http.Client _httpClient;

  HttpNetworkClient() {
    _httpClient = InterceptedClient.build(
      interceptors: [
        LoggingInterceptor(),
        //  CachingInterceptor(),
      ],
      client: http.Client(),
    );
  }

  @override
  Future<http.Response> delete(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _httpClient.delete(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  void dispose() {
    _httpClient.close();
  }

  @override
  Future<http.Response> get(Uri uri, {Map<String, String>? headers}) {
    return _httpClient.get(uri, headers: headers);
  }

  @override
  Future<http.Response> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _httpClient.post(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<http.Response> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _httpClient.put(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<http.Response> postMultipart(
    Uri uri,
    List<http.MultipartFile> files,
    Map<String, String> fields,
  ) async {
    final request = http.MultipartRequest('POST', uri);
    request.persistentConnection = false;
    request.files.addAll(files);
    request.fields.addAll(fields);
    final streamedResponse = await _httpClient.send(request);
    return await http.Response.fromStream(streamedResponse);
  }

  @override
  Future<http.Response> putMultipart(
    Uri uri,
    List<http.MultipartFile> files,
    Map<String, String> fields,
  ) async {
    final request = http.MultipartRequest('PATCH', uri);
    request.persistentConnection = false;
    request.files.addAll(files);
    request.fields.addAll(fields);
    final streamedResponse = await _httpClient.send(request);
    return await http.Response.fromStream(streamedResponse);
  }
}
