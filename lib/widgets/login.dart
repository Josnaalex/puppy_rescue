import 'package:flutter/material.dart';
import 'package:newapp/widgets/createaccount.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInScreen extends 
StatefulWidget
 
{
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class
 
_SignInScreenState
 
extends
 
State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration:
 
const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return
 
'Please enter your email address';
                  }
                  final regex = RegExp(r'\w+@\w+\.\w+');
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return
 
'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return
 
null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Perform sign-in logic here
                    // Navigator.pop(context);
                    final email = _emailController.text;
                    final pword = _passwordController.text;
                    final supabase = Supabase.instance.client;
                  
                    final data = await supabase
                      .from('users')
                      .select('id')
                      .match({'email': email, 'password': pword}); // Pass in email and pword to select statement
                    if (data.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid email or password'),
                        backgroundColor: Colors.red,
                      ));}
                    if(data.length > 0){
                      String userId = "";
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('userID', data[0]['id']);
                      await OneSignal.shared.getDeviceState().then((deviceState) {
                          userId = deviceState!.userId.toString(); // Use this ID to identify the user
                      });
                      await supabase.from('users').upsert({
                        'id': data[0]['id'],
                        'onesignaluserid': userId
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/userhome');
                    }
                    else{
                      // provide error message
                    }
                  }

                },
                child: Text('Sign In'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the create account screen here
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountScreen()));
                },
                child: Text('Create New Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}