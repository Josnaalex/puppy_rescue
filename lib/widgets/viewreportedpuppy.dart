import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
final supabase = Supabase.instance.client;

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
  dynamic reportDetails;
  dynamic user;
  bool foundClicked = false;

  @override
   void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
         reportDetails = ModalRoute.of(context)?.settings.arguments as Map?;
         print(reportDetails);
      // Fetch image URL from Supabase storage
      final String publicUrl = supabase.storage
        .from('stray') // Replace with your bucket name
        .getPublicUrl("puppy/${reportDetails!['reportId']}.jpg") ;// Replace with your image path
        user = reportDetails['user'];
          setState(() {
            _imageURL = publicUrl;
          });
          getUserId();
        
    });
    
  }
  Future puppyStatus() async{
    setState(() {
      foundClicked = true;
    });
    final response = await supabase
          .from('reports')
          .update({'status': 'Puppy is safe'})
          .match({'user_id': user, 'id':reportDetails!['reportId']});
    
    // await supabase
    //     .from('adoption')
    //     .delete()
    //     .match({'id':adoptionId});
      print('Puppy Found');
      print(reportDetails['user']);

    
    }
  @override
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
            foundClicked ? null : puppyStatus();

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