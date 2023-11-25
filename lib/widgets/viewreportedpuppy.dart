import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewPuppy extends StatefulWidget {
  const ViewPuppy({super.key});

  @override
  State<ViewPuppy> createState() => _ViewPuppyState();
}

class _ViewPuppyState extends State<ViewPuppy> {
  @override
  String _imageURL = '';
   dynamic userId;
  bool isLoading = false;

  @override
   void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      final reportId = ModalRoute.of(context)?.settings.arguments as Map?;
      // Fetch image URL from Supabase storage
      final supabase = Supabase.instance.client;
      final String publicUrl = supabase.storage
        .from('stray') // Replace with your bucket name
        .getPublicUrl("puppy/${reportId!['reportId']}.jpg") ;// Replace with your image path
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
            // request();
          } ,
           child: Text('Found'))
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
}