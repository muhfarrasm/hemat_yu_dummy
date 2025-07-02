import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/auth_repository.dart';
import 'package:hematyu_app_dummy_fix/data/repository/chart_repository.dart';
import 'package:hematyu_app_dummy_fix/data/repository/dashboard_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/bloc/auth_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/login_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/register_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/welcome.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/chart/bloc/chart_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/dashboard/dashboard_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/main_page.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

void main() {
  final httpClient = ServiceHttpClient();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(httpClient)),
        RepositoryProvider(
          create: (_) => DashboardRepository(httpClient: httpClient),
        ),
        RepositoryProvider(
          create: (_) => ChartRepository(httpClient: httpClient),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create:
                (context) => DashboardBloc(
                  repository: context.read<DashboardRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => ChartBloc(
                  repository: context.read<ChartRepository>(),
                  token: '', // Sementara kosong, inject token di runtime!
                ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HematYu App',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/MainPage': (context) => const MainPage(),
      },
    );
  }
}
