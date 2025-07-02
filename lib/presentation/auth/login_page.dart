import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';
import 'package:hematyu_app_dummy_fix/data/model/request/auth/login_request_model.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _registerSuccessHandled = false;
  bool _passwordVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Tangkap hasil dari RegisterPage
    final fromRegister = ModalRoute.of(context)?.settings.arguments as bool?;

    // Jika register berhasil, tampilkan snackbar, hanya sekali
    if (fromRegister == true && !_registerSuccessHandled) {
      _registerSuccessHandled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Register berhasil! Silakan login.')),
        );
      });
    }
  }

  void _onLoginPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final loginRequest = LoginRequestModel(email: email, password: password);
    context.read<AuthBloc>().add(LoginRequested(loginRequest));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.lightTextColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Login sukses!")));
              Navigator.pushReplacementNamed(context, '/MainPage');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },

          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: AppColors.inputFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: AppColors.inputFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible 
                            ? Icons.visibility_off 
                            : Icons.visibility,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.lightTextColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: state is AuthLoading ? null : _onLoginPressed,
                    child:
                        state is AuthLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/register',
                    );
                    if (result == true) {
                      setState(
                        () {},
                      ); // Refresh UI agar didChangeDependencies terpanggil
                    }
                  },
                  child: const Text("Belum punya akun? Daftar di sini"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
