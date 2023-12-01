import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final client = Supabase.instance.client;

class CreateShelterAccount extends StatefulWidget {
    const CreateShelterAccount({Key? key}) : super(key: key);


  @override
  State<CreateShelterAccount> createState() => _CreateShelterAccountState();
}

class _CreateShelterAccountState extends State<CreateShelterAccount> {
  
  
    final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

    final _licenseController = TextEditingController();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool error = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: SingleChildScrollView(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
 
const InputDecoration(
                  labelText: 'Shelter Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your shelter name';
                  }
                  return
 
null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
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
              error? Text('This email id already exists',style: TextStyle(
                color: Colors.red
              ),):Text(''),
              SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Location';
                  }
                return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _licenseController,
                decoration: const InputDecoration(
                  labelText: 'License number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your license no';
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
                  
                  return
 
null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone no';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
              child:ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                    createUser();
                  // }
                },
                child: Text('Create Account'),
              ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final address = _addressController.text;
    final phone = _phoneController.text;
    final license =_licenseController.text;
    final response = await client.from('shelters').select('id').match({'email':email});
    if(response.length > 0)
    {
      setState(() {
        error=true;
      });
    }
    else{
     await client.from('pending_approval').insert({
      'shelter_name': name,
      'email': email,
      'password': password,
      'location': address,
      'phone' : phone,
      'license_no' :license,

    });}

    // if (response.error != null) {
    //   print('Error creating account: ${response.error}');
    //   return;
    // }

    // print('Account created successfully!');
    // Navigator.pop(context);
  }
  
}