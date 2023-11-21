import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
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

  String? _loc = '';
  String? _landmark = '';
  String? _selectedShelter = 'Josna';
  dynamic shelterIds;
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  final _locController = TextEditingController();
  final _landController = TextEditingController();

  XFile? _image;
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
    print(data);
    // print(response);
    // if (response != null) {
    //   // Handle error
    //   return;
    // }

    // final data = response.data as List<Map<String, dynamic>>;
    // final shelterNames = data.map((e) => e['name' 'id']).cast<String>().toList();
    final shelterNames =
        data.map<String>((e) => e['location'].toString()).toList();
    shelterIds = Map.fromIterables(
        shelterNames, data.map<String>((e) => e['id'].toString()).toList());
    print("Shelter Ids: ${shelterIds}");
    // AnimalShelterItem animalShelter = AnimalShelterItem(_selectedShelter.id, _selectedShelter.location);

    // final shelterId = _selectedShelter!.id;
    setState(() {
      animalShelters = shelterNames;
      _selectedShelter = animalShelters.first;
    });
  }
  // // void retrieveAnimalShelterNames() async {
  // //   // Connect to Supabase database
  // //   final supabase = Supabase.instance.client;
  // //   //  List<Map<String, dynamic>> shelterNames = [];
  // //   // Execute SQL query to fetch animal shelter names
  // //   final response = await supabase.from('shelters').select('name').execute();

  // //   // Process query results and extract shelter names

  // //     final List<String> shelterNames = response.data.map((shelter) => shelter['name'].toString()).toList();

  // //   // animalShelters = shelterNames.map((shelter) => shelter['name'] as String).toList();

  // //   // Update state to reflect the updated animal shelter list
  // //   setState(() {

  // //   });
  // }

  Future<void> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
        final imagePath = pickedImage.path;
        imageFile = File(imagePath);

      //   final supabase = Supabase.instance.client;
      //   final String weblink = await supabase.storage.from('stray').upload(
      //   'puppy/puppy1.jpg',
      //   imageFile,
      //   fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      // );

      //   print(weblink);
      setState(() {
        _image = pickedImage;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _location = '${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> insertReport() async {
    print(shelterIds[_selectedShelter]);

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
                  onPressed: _pickImage,
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
                // Location Input Field
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'Location',
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter a location';
                //     }
                //     return null;
                //   },
                //   onSaved: (newValue) => _loc = newValue,
                // ),
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

                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'Landmark',
                //   ),
                //   onSaved: (newValue) => _landmark = newValue,
                // ),
                SizedBox(height: 20),

                // Animal Shelter Selection Dropdown
                // DropdownButton<int>(
                //     value: _selectedShelter,
                //     items: animalShelters.map((shelter) => DropdownMenuItem(
                //       child: Text(shelter.name),
                //       value: shelter.id,
                //     )).toList(),
                //     onChanged: (newValue) => setState(() => _selectedShelter = newValue!),
                //   ),

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
                // Text('GPS Location: $_location'),
                // SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: _getCurrentLocation,
                //   child: Text('Get Current Location'),
                // ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Perform form submission logic here
                      // Use _image.path to access the selected image path
                      // Use _location to access the GPS location
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
