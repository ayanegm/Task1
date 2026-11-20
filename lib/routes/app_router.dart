import 'package:auth/pages/about_page.dart';
import 'package:auth/pages/home_screen.dart';
import 'package:auth/pages/login_page.dart';
import 'package:auth/routes/app_routes.dart';
import 'package:auth/services/auth_service.dart';

import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.homePage,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.aboutPage,
        builder: (context, state) {
          final title = state.extra as String?;
          return AboutPage(title: title ?? "No value was passed");
        },
      ),

      GoRoute(
        path: AppRoutes.loginPage,
        builder: (context, state) => LoginPage(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = AuthService.instance.isLoggedIn;
      final islogRoute = state.matchedLocation == AppRoutes.loginPage;

      if (!isLoggedIn && !islogRoute) {
        return AppRoutes.loginPage;
      }
      if (isLoggedIn && islogRoute) {
        return AppRoutes.homePage;
      }
      return null;
    },
    initialLocation: AppRoutes.homePage,
    refreshListenable: AuthService.instance,
  );
}
