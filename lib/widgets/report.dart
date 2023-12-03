import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationAndImageForm extends StatefulWidget {
  const LocationAndImageForm({Key? key}) : super(key: key);

  @override
  State<LocationAndImageForm> createState() => _LocationAndImageFormState();
}

class AnimalShelterItem {
  final int id;
  final String name;

  AnimalShelterItem({required this.id, required this.name});
}

class _LocationAndImageFormState extends State<LocationAndImageForm> {
  List<String> animalShelters = [];
  String? _selectedShelter = 'Josna';
  dynamic shelterIds;
  final _formKey = GlobalKey<FormState>();
  final _locController = TextEditingController();
  final _landController = TextEditingController();

  XFile? _image;
  // ignore: unused_field, prefer_final_fields
  String _location = '';
  dynamic imageFile;

  @override
  void initState() {
    super.initState();
    _fetchData();

    // Retrieve animal shelter names from Supabase database
    // retrieveAnimalShelterNames();
  }

  Future<void> _fetchData() async {
    final supabase = Supabase.instance.client;

    final data = await supabase.from('shelters').select('location, id');
    final shelterNames =
        data.map<String>((e) => e['location'].toString()).toList();
    shelterIds = Map.fromIterables(
        shelterNames, data.map<String>((e) => e['id'].toString()).toList());
    // AnimalShelterItem animalShelter = AnimalShelterItem(_selectedShelter.id, _selectedShelter.location);

    // final shelterId = _selectedShelter!.id;
    setState(() {
      animalShelters = shelterNames;
      _selectedShelter = animalShelters.first;
    });
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
                // ignore: use_build_context_synchronously
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
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
              },
              
                  
                ),
          ]
        );
      }
    );
  }
  Future<void> insertReport() async {
    final supabase = Supabase.instance.client;
    final report = {
      'location': _locController.text,
      'landmark': _landController.text,
      'shelter_id': shelterIds[_selectedShelter],
      'image_url': _image?.path,
    };

    final res = await supabase.from('reports').insert(report).select();
     await supabase.storage.from('stray').upload(
        'puppy/${res[0]['id']}.jpg',
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report the spotted Puppy'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
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
                  controller: _locController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Landmark Input Field
                TextFormField(
                  controller: _landController,
                  decoration: const InputDecoration(
                    labelText: 'Landmark',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a landmark';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: _selectedShelter,
                  onChanged: (String? newValue) => setState(() {
                    _selectedShelter = newValue;
                  }),
                  items:
                      animalShelters.map<DropdownMenuItem<String>>((shelter) {
                    return DropdownMenuItem(
                      value: shelter,
                      child: Text(shelter),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      insertReport();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
