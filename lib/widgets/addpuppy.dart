import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AddPuppy extends StatefulWidget {
  const AddPuppy({Key? key}) : super(key: key);

  @override
  State<AddPuppy> createState() => _AddPuppyState();
}


class _AddPuppyState extends State<AddPuppy> {
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _shelternameController = TextEditingController();
  final _shelterlocationController = TextEditingController();
  final _imagePicker = ImagePicker();
  dynamic userId;
  bool isLoading = false;
  final supabase = Supabase.instance.client;


    dynamic imageFile;
      XFile? _image;
  @override
  void initState() {
    super.initState();
    getUserId();
  }
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Pick Image from Camera'),
              onTap: () async {
                final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                
                  if (pickedImage != null) {
                    final imagePath = pickedImage.path;
                    imageFile = File(imagePath);
                  }
                    setState(() {
                    _image = pickedImage;
                  
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Pick Image from Gallery'),
              onTap: () async {
                final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                
                  if (pickedImage != null) {
                    final imagePath = pickedImage.path;
                    imageFile = File(imagePath);
                  }
                  setState(() {
                     _image = pickedImage;
                  });
                  Navigator.pop(context);
              },
              
                  
                ),
          ]
        );
      }
    );
  }
                
              
      
    
  

  // Future<void> _pickImage() async {
  //   final pickedImage =
  //       await _imagePicker.pickImage(source: ImageSource.camera);
  //   if (pickedImage != null) {
  //       final imagePath = pickedImage.path;
  //       imageFile = File(imagePath);

  //     //   final supabase = Supabase.instance.client;
  //     //   final String weblink = await supabase.storage.from('stray').upload(
  //     //   'puppy/puppy1.jpg',
  //     //   imageFile,
  //     //   fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
  //     // );

  //     //   print(weblink);
  //     setState(() {
  //       _image = pickedImage;
  //     });
  //   }
  // }
  Future<void> insertPuppy() async {

    final supabase = Supabase.instance.client;
    final adopt = {
      'breed': _breedController.text,
      'age': _ageController.text,
      'shelter_name': _shelternameController.text,
      'shelter_location': _shelterlocationController.text,
      'shelter_id': userId,
  
    };

    final res = await supabase.from('adoption').insert(adopt).select();
     await supabase.storage.from('adoption').upload(
        'puppy1/${res[0]['id']}.jpg',
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add puppy'),
      ),
      body:SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null)
                  Image.file(
                    File(_image!.path),
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _showBottomSheet,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Take Image'),
                ),
                SizedBox(height: 20),
              TextFormField(
                controller: _breedController,
                decoration:
 
const InputDecoration(
                  labelText: 'Puppy breed',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter puppy breed';
                  }
                  return
 
null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return
 
'Please enter age of puppy';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _shelternameController,
                decoration: const InputDecoration(
                  labelText: 'Shelter name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Shelter name';
                  }
                return null;
                },
              ),

              SizedBox(height: 20),
              TextFormField(
                controller: _shelterlocationController,
                decoration: const InputDecoration(
                  labelText: 'Shelter location',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return
 
'Please enter shelter location';
                  }
                  return
 
null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                    insertPuppy();
                    Navigator.pop(context);
                  // }
                  SnackBar snackBar = SnackBar(
        content: Text('Puppy details added successfully!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text('Add puppy'),
              ),
            ],
          ),
       
        ),
    );
  }
   Future getUserId() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userID');
    setState(() {
      isLoading = false;
    });
  }
}

