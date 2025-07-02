// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hematyu_app_dummy_fix/data/model/request/auth/login_request_model.dart';
// import 'package:hematyu_app_dummy_fix/data/model/response/auth/login_response_model.dart';
// import 'package:hematyu_app_dummy_fix/data/model/response/auth/auth_data.dart';
// import 'package:hematyu_app_dummy_fix/data/repository/auth_repository.dart';
// import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_bloc.dart';
// import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_event.dart';
// import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_state.dart';
// import 'package:mocktail/mocktail.dart';

// class MockAuthRepository extends Mock implements AuthRepository {}

// void main() {
//   group('AuthBloc', () {
//     late AuthBloc authBloc;
//     late AuthRepository authRepository;
//     late LoginResponseModel loginResponse;

//     final loginRequest = LoginRequestModel(
//       email: 'test@example.com',
//       password: 'password',
//     );

//     setUp(() {
//       authRepository = MockAuthRepository();
//       authBloc = AuthBloc(authRepository: authRepository);

//       final authData = AuthData(
//         user: User(id: 1, username: 'testuser', email: 'test@example.com'),
//         token: 'token_example',
//         tokenType: 'bearer',
//         expiresIn: 3600,
//       );

//       loginResponse = LoginResponseModel(
//         status: 'success',
//         message: 'Login successful',
//         data: authData,
//       );
//     });

//     blocTest<AuthBloc, AuthState>(
//       'emits [AuthLoading, AuthSuccess] on successful login',
//       build: () {
//         when(() => authRepository.login(loginRequest))
//             .thenAnswer((_) async => loginResponse);
//         return authBloc;
//       },
//       act: (bloc) => bloc.add(LoginRequested(loginRequest)),
//       expect: () => [
//         AuthLoading(),
//         AuthSuccess(loginResponse.data!),
//       ],
//       verify: (_) {
//         verify(() => authRepository.login(loginRequest)).called(1);
//       },
//     );

//     blocTest<AuthBloc, AuthState>(
//       'emits [AuthLoading, AuthFailure] on failed login',
//       build: () {
//         when(() => authRepository.login(loginRequest))
//             .thenThrow(Exception('Login failed'));
//         return authBloc;
//       },
//       act: (bloc) => bloc.add(LoginRequested(loginRequest)),
//       expect: () => [
//         AuthLoading(),
//         isA<AuthFailure>(),
//       ],
//       verify: (_) {
//         verify(() => authRepository.login(loginRequest)).called(1);
//       },
//     );
//   });
// }
