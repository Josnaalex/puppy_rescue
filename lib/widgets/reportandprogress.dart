import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReportAndProgress extends StatefulWidget {
  const ReportAndProgress({Key? key}) : super(key: key);

  @override
  State<ReportAndProgress> createState() => _ReportAndProgressState();
}

class AnimalShelterItem {
  final int id;
  final String name;

  AnimalShelterItem({required this.id, required this.name});
}

class _ReportAndProgressState extends State<ReportAndProgress> {
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
  dynamic userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();

    // Retrieve animal shelter names from Supabase database
    // retrieveAnimalShelterNames();
  }

  Future<void> _fetchData() async {
    final supabase = Supabase.instance.client;
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userID');
    final data = await supabase.from('shelters').select('location, id');
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
      isLoading = false;
    });
  }

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

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     final Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     setState(() {
  //       _location = '${position.latitude}, ${position.longitude}';
  //     });
  //   } catch (e) {
  //     print('Error getting location: $e');
  //   }
  // }
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
  Future sendPushNotification(String userId, String message) async {

    await dotenv.load(fileName: ".env");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': dotenv.env['URL']!,
    };

    var body = {
      'app_id': dotenv.env['APP_ID']!,
      'include_player_ids': [userId],
      'contents': {'en': message},
    };

    await http.post(
      Uri.parse("https://onesignal.com/api/v1/notifications"),
      headers: headers,
      body: jsonEncode(body),
    );

  }

  Future<void> insertReport() async {
    print(shelterIds[_selectedShelter]);

    final supabase = Supabase.instance.client;
    final report = {
      'location': _locController.text,
      'landmark': _landController.text,
      'shelter_id': shelterIds[_selectedShelter],
      'image_url': _image?.path,
      'user_id': userId,
    };

    final res = await supabase.from('reports').insert(report).select();
    await supabase.storage.from('stray').upload(
          'puppy/${res[0]['id']}.jpg',
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    // final prefs = await SharedPreferences.getInstance();
    // final userID = prefs.getInt('userID');
    final shelter = await supabase.from('shelters').select('onesignaluserid').match({
      'id':report['shelter_id']
    });
    final message = "A new puppy is reported at ${_locController.text}.";

    sendPushNotification(shelter[0]['onesignaluserid'], message);

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
