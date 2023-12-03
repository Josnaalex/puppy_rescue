import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final supabase = Supabase.instance.client;

class AddPuppy extends StatefulWidget {
  const AddPuppy({Key? key}) : super(key: key);

  @override
  State<AddPuppy> createState() => _AddPuppyState();
}

class _AddPuppyState extends State<AddPuppy> {
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  dynamic userId;
  bool isLoading = false;
  dynamic response;

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
          return Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              title: Text('Pick Image from Camera'),
              onTap: () async {
                final pickedImage =
                    await ImagePicker().pickImage(source: ImageSource.camera);

                if (pickedImage != null) {
                  final imagePath = pickedImage.path;
                  imageFile = File(imagePath);
                }
                setState(() {
                  _image = pickedImage;
                });
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Pick Image from Gallery'),
              onTap: () async {
                final pickedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (pickedImage != null) {
                  final imagePath = pickedImage.path;
                  imageFile = File(imagePath);
                }
                setState(() {
                  _image = pickedImage;
                });
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
          ]);
        });
  }

  Future<void> insertPuppy() async{
    final adopt = {
      'breed': _breedController.text,
      'age': _ageController.text,
      'shelter_name': response[0]['name'],
      'shelter_location': response[0]['location'],
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
      body: SingleChildScrollView(
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
              decoration: const InputDecoration(
                labelText: 'Puppy breed',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter puppy breed';
                }
                return null;
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
                  return 'Please enter age of puppy';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // if (_formKey.currentState!.validate()) {
                insertPuppy();

                // }
                 ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Puppy Added Successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                       Future.delayed(Duration(seconds: 2), () {
                       Navigator.pop(context);
                      });
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
    response = await supabase.from('shelters').select().match({'id': userId});
    setState(() {
      isLoading = false;
    });
  }
}
