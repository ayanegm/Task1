import 'package:auth/pages/about_page.dart';
import 'package:auth/pages/home_screen.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed("home");
            },
            child: Text('pushNamed to home page'),
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
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                //it will remove all the pages and store the homeScreen
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            },
            child: Text('pushAndRemoveUntil button'),
          ),
        ],
      ),
    );
  }
}
