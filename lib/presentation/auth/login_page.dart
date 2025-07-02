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

    final fromRegister = ModalRoute.of(context)?.settings.arguments as bool?;

    if (fromRegister == true && !_registerSuccessHandled) {
      _registerSuccessHandled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Register berhasil! Silakan login.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.successColor,
          ),
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
        title: const Text('Masuk'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Illustration
            Image.asset(
              'assets/images/finance.png',
              height: 180,
            ),
            const SizedBox(height: 24),
            
            // Form Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoginSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Login berhasil!"),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: AppColors.successColor,
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/MainPage');
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: AppColors.errorColor,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        // Email Field
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined, 
                                color: AppColors.primaryColor),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outlined, 
                                color: AppColors.primaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible 
                                    ? Icons.visibility_off 
                                    : Icons.visibility,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                setState(() => _passwordVisible = !_passwordVisible);
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              shadowColor: AppColors.primaryColor.withOpacity(0.3),
                            ),
                            onPressed: state is AuthLoading ? null : _onLoginPressed,
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'MASUK',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Register Prompt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun?"),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    "Daftar disini",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}