import 'package:equatable/equatable.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/auth/auth_data.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/auth/me_response_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final AuthData data;

  AuthLoginSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class AuthRegisterSuccess extends AuthState {
  final AuthData data;

  AuthRegisterSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class AuthMeLoaded extends AuthState {
  final MeData data;

  AuthMeLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthLoggedOut extends AuthState {}
