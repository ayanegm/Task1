import 'package:auth/routes/app_routes.dart';
import 'package:auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LoginPage')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AuthService.instance.LogIn();
            context.go(AppRoutes.homePage);
          },
          child: Text('Sign in'),
        ),
      ),
    );
  }
}
