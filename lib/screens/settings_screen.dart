import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  static const routeName = '/settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppBar(title: Text('Settings'),),
      
      ),
      body: Center(
        child: Text('Loading....'),
      ),
    );
  }
}