import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
  final client = Supabase.instance.client;


class AdoptPuppy extends StatefulWidget {
  const AdoptPuppy({super.key});

  @override
  State<AdoptPuppy> createState() => _AdoptPuppyState();
}

class _AdoptPuppyState extends State<AdoptPuppy> {
  String _imageURL = '';
   dynamic userId;
  bool isLoading = false;
  dynamic adoptionDetails;

  @override
   void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      adoptionDetails = ModalRoute.of(context)?.settings.arguments as Map?;
      // Fetch image URL from Supabase storage
      final supabase = Supabase.instance.client;
      final String publicUrl = supabase.storage
        .from('adoption') // Replace with your bucket name
        .getPublicUrl("puppy1/${adoptionDetails!['adoptionId']}.jpg") ;// Replace with your image path
          setState(() {
            _imageURL = publicUrl;
          });
          getUserId();
        
    });
    
  }
  
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puppy Image'),
      ),
      body: Column(
        children: [
          Center(
            child: _imageURL.isNotEmpty
                ? Image.network(_imageURL)
                : CircularProgressIndicator(),  
          ),
          ElevatedButton(onPressed: () {
            request();
            Navigator.pop(context);
          } ,
           child: Text('Request for Adoption'))
        ],
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
  Future<void> request() async {


     await client.from('adoption_requests').insert({
      'user_id': userId,
      'shelter_id': adoptionDetails['shelterId'],
      'adoption_id': adoptionDetails!['adoptionId'],

    });
  }
}
