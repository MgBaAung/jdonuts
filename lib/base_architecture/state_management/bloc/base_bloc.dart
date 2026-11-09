import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/master_object.dart';
import '../../domain/usecase/baste_usecase.dart';
import 'api_event.dart';
import 'api_state.dart';

class BaseBloc<T extends MasterObject<T>> extends Bloc<ApiEvent, ApiState> {
  final CrudUseCase<T> crudUsecase;

  BaseBloc({required this.crudUsecase}) : super(const ApiInitial()) {
    on<FetchAllDataEvent<T>>(_onFetchAllData);
    on<FetchDataEvent<T>>(_onFetch);
    on<CreateDataEvent<T, T>>(onCreate);
    on<UpdateDataEvent<T, T>>(_onUpdate);
    on<DeleteDataEvent<T>>(onDelete);
    on<RequestEmptyEvent<T, T>>(_onRequestEmptyBody);
    on<UploadeFileEvent<dynamic, T>>(_onUploaded);
    on<PutFileEvent<dynamic, T>>(_onPutFormData);
  }

  Future<void> _onFetchAllData(
    FetchAllDataEvent<T> event,
    Emitter<ApiState> emit,
  ) async {
    List<T> existingData = [];
    if (state is ApiSuccess<List<T>>) {
      existingData = (state as ApiSuccess<List<T>>).data;
    } else if (state is ApiSuccessNoMoreData<List<T>>) {
      existingData = (state as ApiSuccessNoMoreData<List<T>>).data;
    } else {
      existingData = [];
    }
    if (!event.shouldAppend) {
      emit(const ApiLoading());
    }

    try {
      final response = await crudUsecase.getList(
        endpoint: event.endpoint,
        parser: event.parser,
        queryParams: event.queryParams,
      );

      if (response.success && response.data != null) {
        List<T> newItems = response.data!;
        List<T> finalData = existingData;

        if (event.shouldAppend) {
          if (newItems.isEmpty) {
            emit(ApiSuccessNoMoreData<List<T>>(existingData));
            return;
          }
          finalData = List<T>.from(existingData)..addAll(newItems);
        } else {
          finalData = newItems;
        }
        emit(ApiSuccess<List<T>>(finalData));
      } else {
        emit(
          ApiFailure(
            response.message ?? 'failed to fetch data',
            statusCode: response.statusCode,
            error: "",
          ),
        );
      }
    } catch (e) {
      emit(ApiFailure('Unexpect error: $e', error: e));
    }
  }

  Future<void> _onFetch(FetchDataEvent<T> event, Emitter<ApiState> emit) async {
    emit(const ApiLoading());
    try {
      final response = await crudUsecase.get(
        endpoint: event.endpoint,
        parser: event.parser,
        isList: event.isList,
        queryParams: event.queryParams,
      );

      if (response.success && response.data != null) {
        emit(ApiSuccess<T>(response.data!));
      } else {
        emit(
          ApiFailure(
            response.message ?? 'failed to fetch data',
            statusCode: response.statusCode,
            error: "",
          ),
        );
      }
    } catch (e) {
      emit(ApiFailure('Unexpect error: $e', error: e));
    }
  }

  Future<void> onCreate(
    CreateDataEvent<T, T> event,
    Emitter<ApiState> emit,
  ) async {
    emit(const ApiLoading());
    try {
      final response = await crudUsecase.create(
        endpoint: event.endpoint,
        data: event.data,
        parser: event.parser,
      );

      if (response.success && response.data != null) {
        emit(ApiSuccess<T>(response.data!));
      } else {
        emit(
          ApiFailure(
            response.message ?? 'failed to fetch data',
            statusCode: response.statusCode,
            error: "",
          ),
        );
      }
    } catch (e) {
      emit(ApiFailure('Unexpected error: $e', error: e));
    }
  }

  Future<void> _onRequestEmptyBody(
    RequestEmptyEvent<T, T> event,
    Emitter<ApiState> emit,
  ) async {
    emit(const ApiLoading());
    try {
      final response = await crudUsecase.postWithoutBody(
        endpoint: event.endpoint,
        data: event.data,
        parser: event.parser,
      );

      if (response.success && response.data != null) {
        emit(ApiSuccess<T>(response.data!));
      } else {
        emit(
          ApiFailure(
            response.message ?? 'failed to fetch data',
            statusCode: response.statusCode,
            error: "",
          ),
        );
      }
    } catch (e) {
      emit(ApiFailure('Unexpected error: $e', error: e));
    }
  }

  Future<void> _onUpdate(
    UpdateDataEvent<T, T> event,
    Emitter<ApiState> emit,
  ) async {
    try {
      final response = await crudUsecase.update(
        endpoint: event.endpoint,
        id: event.id,
        data: event.data,
        parser: event.parser,
      );

      if (response.success && response.data != null) {
        final updatedItem = response.data!;

        List<T> currentList = [];
        if (state is ApiSuccess<List<T>>) {
          currentList = List<T>.from((state as ApiSuccess<List<T>>).data);
        } else if (state is ApiSuccessNoMoreData<List<T>>) {
          currentList = List<T>.from(
            (state as ApiSuccessNoMoreData<List<T>>).data,
          );
        }

        final updatedList = currentList.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();

        if (currentList.isNotEmpty) {
          emit(ApiSuccess<List<T>>(updatedList));
          return;
        }
      } else {
        emit(
          ApiFailure(
            response.message ?? 'failed to update data',
            statusCode: response.statusCode,
            error: "",
          ),
        );
      }
    } catch (e) {
      emit(ApiFailure('Unexpected error: $e', error: e));
    }
  }

  Future<void> onDelete(
    DeleteDataEvent<T> event,
    Emitter<ApiState> emit,
  ) async {
    emit(const ApiLoading());

    try {
      final response = await crudUsecase.delete(
        event.endpoint,
        event.id,
        event.parser,
      );

      if (response.success && response.data != null) {
        emit(ApiSuccess<T>(response.data!));
      } else {
        emit(
          ApiFailure(
            response.message ?? 'Failed to delete by ${event.id}',
            statusCode: response.statusCode,
            error: "",
          ),
        );
      }
    } catch (e) {
      emit(ApiFailure('Unexpected error: $e', error: e));
    }
  }

  Future<void> _onUploaded(
    UploadeFileEvent<dynamic, T> event,
    Emitter<ApiState> emit,
  ) async {
    emit(const ApiLoading());
    try {
      final response = await crudUsecase.uploade(
        fields: event.data,
        endpoint: event.endpoint,
        file: event.file,
        parser: event.parser,
        fieldName: event.fieldName,
      );
      if (response.success && response.data != null) {
        emit(ApiSuccess<T>(response.data!));
      } else {
        emit(
          ApiFailure(
            response.message ?? 'failed to fetch data',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e) {
      emit(ApiFailure('Unexpected error: $e'));
    }
  }

  Future<void> _onPutFormData(
    PutFileEvent<dynamic, T> event,
    Emitter<ApiState> emit,
  ) async {
    emit(const ApiLoading());
    try {
      final response = await crudUsecase.putMultiPartForm(
        fields: event.data,
        endpoint: event.endpoint,
        file: event.file,
        parser: event.parser,
        fieldName: event.fieldName,
      );
      if (response.success && response.data != null) {
        emit(ApiSuccess<T>(response.data!));
      } else {
        emit(
          ApiFailure(
            response.message ?? 'failed to fetch data',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e) {
      emit(ApiFailure('Unexpected error: $e'));
    }
  }
}
