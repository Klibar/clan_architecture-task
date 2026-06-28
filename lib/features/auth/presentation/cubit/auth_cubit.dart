import 'package:clan_architecture/features/auth/data/models/user_model.dart';
import 'package:clan_architecture/features/auth/data/repositories/auth_repository.dart';
import 'package:clan_architecture/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository dataSource = AuthRepository();
  AuthCubit(super.initialState);

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      final result = await dataSource.login(
        LoginRequestModel(email: email, password: password),
      );
      emit(
        LoginSuccessState(user: result.user, message: 'Logged in Sccessfuly'),
      );
    } catch (e) {
      emit(LoginErrorState(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(RegisterLoadingState());
    try {
      final result = await dataSource.register(
        RegisterRequestModel(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      );
      emit(
        RegisterSuccessState(
          user: result.user,
          message: 'Registered Successfully',
        ),
      );
    } catch (e) {
      emit(RegisterErrorState(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
