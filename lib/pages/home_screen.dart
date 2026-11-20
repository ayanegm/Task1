import 'package:auth/pages/about_page.dart';
import 'package:auth/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")),

      body: Column(
        children: [
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AboutPage(title: "hello from home (push Navigator)");
                  },
                ),
              );
            },
            child: Text('push to about page'),
          ),
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AboutPage(
                    title: "hello from home (pushReplacement Navigator)",
                  ),
                ),
              );
            },
            child: Text('push replacement to about page'),
          ),
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('pop button'),
          ),
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () => context.go(
              AppRoutes.aboutPage,
              extra: 'gorouter push from homePagen to aboutPage',
            ),
            child: Text('gorouter push button'),
          ),
        ],
      ),
    );
  }
}
//we use pushReplacemnet when login , because we will not go back from homePag e to login
// push when something like homePage  ans setting Page we can go back again
