import '../../core/api_response.dart';
import '../../core/base_entity.dart';
import '../../core/master_object.dart';
import '../../data/local_datasource/local_datasource.dart';
import 'api_repository.dart';

class ApiRepositoryWithLocalStorage<
  T extends MasterObject<T>,
  E extends BaseEntity<T, E>
>
    extends ApiRepository<T> {
  final LocalDataSource<T, E> localDataSource;

  ApiRepositoryWithLocalStorage({
    required super.networkClient,
    required this.localDataSource,
  });

  @override
  Future<ApiResponse<T>> get<T>(
    String endPoint,
    T Function(dynamic p1) parser, {
    Map<String, dynamic>? queryParams,
    bool isList = false,
  }) async {
    try {
      final cachedData = await localDataSource.getAll();
      if (!isList && cachedData.isNotEmpty) {
        return ApiResponse<T>(success: true, data: cachedData as T);
      }
      final response = await super.get<T>(
        endPoint,
        parser,
        queryParams: queryParams,
      );
      if (response.success && response.data != null) {
        final data = response.data;
        if (data is Iterable) {
          await localDataSource.clear();
          for (final item in data) {
            await localDataSource.save(item as dynamic);
          }
        } else {
          await localDataSource.save(data as dynamic);
        }
      }
      return response;
    } catch (e) {
      return ApiResponse(success: false, message: 'API failed and post');
    }
  }

  @override
  Future<ApiResponse<TResponse>> post<TRequest, TResponse>(
    String endpoint,
    TRequest? data,
    TResponse Function(dynamic p1) parser,
  ) async {
    final entity = data as T;

    try {
      final apiResponse = await super.post(endpoint, data, parser);
      if (apiResponse.success && apiResponse.data != null) {
        try {
          await localDataSource.clear();
          await localDataSource.save(entity);
          return ApiResponse(success: true, data: entity as TResponse);
        } catch (e) {
          return ApiResponse(success: false, message: 'API failed and post');
        }
      } else {
        return ApiResponse(success: false, message: apiResponse.message);
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'API failed and post');
    }
  }

  @override
  Future<ApiResponse<TResponse>> put<TRequest, TResponse>(
    String endpoint,
    String id,
    TRequest data,
    TResponse Function(dynamic p1) parser,
  ) async {
    final entity = data as T;

    try {
      await localDataSource.clear();
      await localDataSource.save(entity);
      return ApiResponse(success: true, data: entity as TResponse);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'API failed and cache update failed. Cache error: $e',
      );
    }
  }

  @override
  Future<ApiResponse<T>> delete(
    String endpoint,
    String id,
    T Function(dynamic p1) parser,
  ) async {
    try {
      await localDataSource.delete(id);
      final apiResponse = await super.delete(endpoint, id, parser);
      if (apiResponse.success && apiResponse.data != null) {
        await localDataSource.delete(id);
        return apiResponse;
      } else {
        await localDataSource.delete(id);
        return ApiResponse(success: true, message: "delete sucessfully");
      }
    } catch (e) {
      try {
        await localDataSource.delete(id);
        return ApiResponse(success: true);
      } catch (cacheError) {
        return ApiResponse(
          success: false,
          message:
              'API failed and cache delete failed. Error: $e, Cache error: $cacheError',
        );
      }
    }
  }
}
