import 'package:flutter/material.dart';
import 'package:ecommerce_app/widget/auth_form.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
          children: [

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(215, 117, 255, 1),
                  Color.fromRGBO(255,188,177,1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
                )
              ),
            ),
            SingleChildScrollView(
              child:Container(
                height: deviceSize.height,
                width: deviceSize.width,
                child:Column(children: [
                  SizedBox(height: 250,),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 :1,
                    child: AuthCard(),)
                ],)
              )
            )
          ],
      ));
  }
}