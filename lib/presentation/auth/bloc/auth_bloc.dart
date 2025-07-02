import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/auth_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<GetMeRequested>(_onGetMe);
    on<LogoutRequested>(_onLogout);
  }

 Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final result = await authRepository.login(event.loginRequest);
    emit(AuthLoginSuccess(result.data!));
  } catch (e) {
    emit(AuthFailure(e.toString()));
  }
}

Future<void> _onRegister(RegisterRequested event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final result = await authRepository.register(event.registerRequest);
    emit(AuthRegisterSuccess(result.data!));
  } catch (e) {
    emit(AuthFailure(e.toString()));
  }
}


  Future<void> _onGetMe(GetMeRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final me = await authRepository.getMe();
      emit(AuthMeLoaded(me.data!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(AuthLoggedOut());
  }

  // Akses storageService (misal digunakan untuk testing atau penyimpanan token manual)
  FlutterSecureStorage get storageService => authRepository.storageService;
}
