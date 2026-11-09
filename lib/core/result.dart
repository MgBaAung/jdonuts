/// A typed outcome for repository and use-case operations.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failed<T> extends Result<T> {
  const Failed(this.failure);
  final AppFailure failure;
}

sealed class AppFailure implements Exception {
  const AppFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.message);
}

final class StorageFailure extends AppFailure {
  const StorageFailure(super.message);
}

final class DataFailure extends AppFailure {
  const DataFailure(super.message);
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure(super.message);
}

AppFailure mapFailure(Object error) {
  if (error is AppFailure) return error;
  if (error is FormatException) return DataFailure(error.message);
  return StorageFailure('Local data operation failed: $error');
}
