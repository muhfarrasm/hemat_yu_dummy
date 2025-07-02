import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';
import 'package:hematyu_app_dummy_fix/data/model/request/auth/register_request_model.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = RegisterRequestModel(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
      );

      context.read<AuthBloc>().add(RegisterRequested(request));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Daftar Akun Baru"),
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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Pendaftaran berhasil!"),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppColors.successColor,
              ),
            );
            Navigator.pop(context, true);
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header Illustration
                Image.asset(
                  'assets/images/finance.png', // <- Ganti dengan asset baru
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Username Field
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person_outline, 
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
                            validator: (value) => 
                                value!.isEmpty ? 'Username tidak boleh kosong' : null,
                          ),
                          const SizedBox(height: 16),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
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
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return 'Email tidak boleh kosong';
                              if (!value.contains('@')) return 'Email tidak valid';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline, 
                                  color: AppColors.primaryColor),
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
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return 'Password tidak boleh kosong';
                              if (value.length < 6) return 'Minimal 6 karakter';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password Field
                          TextFormField(
                            controller: _passwordConfirmationController,
                            obscureText: !_confirmPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Konfirmasi Password',
                              prefixIcon: Icon(Icons.lock_outline, 
                                  color: AppColors.primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible 
                                      ? Icons.visibility_off 
                                      : Icons.visibility,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible = !_confirmPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Konfirmasi password tidak boleh kosong';
                              }
                              if (value != _passwordController.text) {
                                return 'Password tidak cocok';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // Register Button
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
                              onPressed: state is AuthLoading ? null : _submit,
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'DAFTAR SEKARANG',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun?"),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Masuk disini",
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
          );
        },
      ),
    );
  }
}