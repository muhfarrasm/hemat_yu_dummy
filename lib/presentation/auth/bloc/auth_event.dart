import 'package:equatable/equatable.dart';
import 'package:hematyu_app_dummy_fix/data/model/request/auth/login_request_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/request/auth/register_request_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final LoginRequestModel loginRequest;

  LoginRequested(this.loginRequest);
}

class RegisterRequested extends AuthEvent {
  final RegisterRequestModel registerRequest;

  RegisterRequested(this.registerRequest);
}

class GetMeRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
