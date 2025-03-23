import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/auth/welcome_page.dart';
import 'package:next_gen_ai_healthcare/pages/home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    context.read<AuthBloc>().add(Authenticate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      switch (state) {
        case AuthLoading():
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        case AuthLoadingSuccess():
          return const HomePage();
        case AuthError():
          return const WelcomePage();
        case AuthLogoutState():
          return const WelcomePage();
        default:
          return const WelcomePage();
      }
    });
  }
}
