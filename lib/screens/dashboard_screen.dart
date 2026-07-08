import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {

  const DashboardScreen({super.key});
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WELCOME'),),
      body: Stack(
        children: [
          Text('Welcome back'),
        ],
      ),
    );
  }
}