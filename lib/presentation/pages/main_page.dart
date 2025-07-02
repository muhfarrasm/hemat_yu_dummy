import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/dashboard/dashboard_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/kategori/kategori_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/transaksi_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/target/target_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/widgets/custom_bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  List<Widget> get _pages => [
        const DashboardPage(),
        KategoriPage(onBackToDashboard: () {
          setState(() {
            _currentIndex = 0;
          });
        }),
        TransaksiPage(onBackToDashboard: () {
          setState(() {
            _currentIndex = 0;
          });
        }),
        TargetPage(onBackToDashboard: () {
          setState(() {
            _currentIndex = 0;
          });
        }),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
