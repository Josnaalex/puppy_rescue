import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignInAdmin extends 
StatefulWidget
 
{
  const SignInAdmin({Key? key}) : super(key: key);

  @override
  State<SignInAdmin> createState() => _SignInAdminState();
}

class
 
_SignInAdminState
 
extends
 
State<SignInAdmin> {
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
                  if (value.length < 4) {
                    return 'Password must be at least 4 characters long';
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
                      .from('admin')
                      .select('id')
                      .match({'email': email, 'password': pword}); // Pass in email and pword to select statement
                    if (data.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid email or password'),
                        backgroundColor: Colors.red,
                      ));}
                    
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/adminhome');
                   
                  }

                },
                child: Text('Sign In'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}