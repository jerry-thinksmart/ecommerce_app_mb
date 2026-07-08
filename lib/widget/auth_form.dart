import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

enum AuthMode {
  SignUp,
  Login
}
class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {

  final GlobalKey<FormState> _form = GlobalKey();
  AuthMode _authScreen = AuthMode.Login;
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  var _isLoading = false;

  Map<String, dynamic> _formData = {
    'email': '',
    'password': ''
  };

  void _switchMode(){
    if(_authScreen == AuthMode.Login){
      setState(() {
        _authScreen = AuthMode.SignUp;
      });
    }else{
      setState(() {
        _authScreen  = AuthMode.Login;
      });
    }
  }
  void _showDialog(String message){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('An Error Occured'),
      content: Text(message),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text('Okay')),
      ],
    ));
  }

 Future<void> submitForm() async{
    
   if (_form.currentState!.validate()){
    _form.currentState!.save();
    setState(() {
          _isLoading = true;
        });
      try{
        if(_authScreen == AuthMode.SignUp){
        await Provider.of<Auth>(context, listen: false).signup(_formData['email'], _formData['password']);
        }else{
          await Provider.of<Auth>(context, listen: false).login(_formData['email'], _formData['password']);
        Navigator.of(context).pushReplacementNamed('/dashboard');
          
        }
        
      }catch(e){
        var message = "Could not authenticate you, Try aagin";
        _showDialog(message);
      }
    setState(() {
      _isLoading = false;
    });
   }
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Container(
        height: 320,
        constraints: BoxConstraints(minHeight: 320),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value){
                  _formData['email'] = value as String;
                },
                validator: (value){
                  if(value!.isEmpty || !value.contains('@')){
                    return 'Invalid email!';
                  }
                  return null;
                },),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                controller: password,
                obscureText: true,
                onSaved: (value){
                  _formData['password'] = value as String;
                },
                validator: (value) => (value!.isEmpty || value.length < 5)? 
                'Password is too short' : null
              ),
              if(_authScreen == AuthMode.SignUp)
              TextFormField(
                enabled: _authScreen == AuthMode.SignUp,
                decoration: InputDecoration(labelText: 'ConfirmPassword'),
                obscureText: true,
                validator: (value) => (value == password) ? 'Password mismatch': null,
              ),
              SizedBox(height: 20,),
              if(_isLoading)
              CircularProgressIndicator()
              else
              ElevatedButton(onPressed: submitForm, child: Text(_authScreen == AuthMode.Login ? 'Login' : 'Signup'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4)
                ),
                onPressed: _switchMode, child: Text(' ${_authScreen == AuthMode.Login ? 'Signup': 'Login'} Instead'),),
            ],
          ),
        )),
      ),
    );
  }
}