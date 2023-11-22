import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdoptPuppy extends StatefulWidget {
  const AdoptPuppy({super.key});

  @override
  State<AdoptPuppy> createState() => _AdoptPuppyState();
}

class _AdoptPuppyState extends State<AdoptPuppy> {
  String _imageURL = '';
  @override
   void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      final adoptionId = ModalRoute.of(context)?.settings.arguments as Map?;
      // Fetch image URL from Supabase storage
      final supabase = Supabase.instance.client;
      final String publicUrl = supabase.storage
        .from('adoption') // Replace with your bucket name
        .getPublicUrl("puppy1/${adoptionId!['adoptionId']}.jpg") ;// Replace with your image path
          setState(() {
            _imageURL = publicUrl;
          });
        
    });
    
  }
  
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image from Supabase Storage'),
      ),
      body: Center(
        child: _imageURL.isNotEmpty
            ? Image.network(_imageURL)
            : CircularProgressIndicator(),
      ),
    );
  }
  }
