import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ilustrasi keluarga (ganti dengan asset baru)
              Image.asset(
                'assets/images/familyfix.png', // <- Asset baru
                height: 220,
              ),
              const SizedBox(height: 32),

              // Judul + Subjudul
              Column(
                children: [
                  Text(
                    'Kelola Keuangan Keluarga',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Catat pemasukan/pengeluaran dengan mudah',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Tombol Mulai (dengan gradient)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: AppColors.primaryColor.withOpacity(0.3),
                  ),
                  child: const Text(
                    'Mulai Sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}