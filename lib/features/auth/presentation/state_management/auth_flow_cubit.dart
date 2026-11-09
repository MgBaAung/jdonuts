import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result.dart';
import '../../domain/auth_usecase.dart';

class AuthFlowState {
  const AuthFlowState({this.isLoading = false, this.failure});
  final bool isLoading;
  final AppFailure? failure;
}

/// Runs authentication use cases and exposes typed operation state to widgets.
class AuthFlowCubit extends Cubit<AuthFlowState> {
  AuthFlowCubit(this._authUsecase) : super(const AuthFlowState());
  final AuthUsecase _authUsecase;
  Future<Result<bool>>? _loginInFlight;
  Future<Result<void>>? _registerInFlight;

  Future<Result<bool>> loginIfRegistered(String phone) {
    return _loginInFlight ??= _runLogin(phone).whenComplete(() {
      _loginInFlight = null;
    });
  }

  Future<Result<bool>> _runLogin(String phone) async {
    emit(const AuthFlowState(isLoading: true));
    final result = await _authUsecase.loginIfRegistered(phone);
    if (!isClosed) {
      emit(
        result is Failed<bool>
            ? AuthFlowState(failure: result.failure)
            : const AuthFlowState(),
      );
    }
    return result;
  }

  Future<Result<void>> register({
    required String phone,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) {
    return _registerInFlight ??= _runRegister(
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
    ).whenComplete(() {
      _registerInFlight = null;
    });
  }

  Future<Result<void>> _runRegister({
    required String phone,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) async {
    emit(const AuthFlowState(isLoading: true));
    final result = await _authUsecase.register(
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
    );
    if (!isClosed) {
      emit(
        result is Failed<void>
            ? AuthFlowState(failure: result.failure)
            : const AuthFlowState(),
      );
    }
    return result;
  }
}
