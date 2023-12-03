import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;
class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isLoading = false;
  dynamic requestList = [{"name": "", "email": "", "address": "","phone":""}];
  @override
  void initState() {
    super.initState();
    getUserId();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        children: [
          // Display the user's avatar
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQCX5_wYEa6hyWoqSBOaPbaHw5Ff8Ljp0WcA&usqp=CAU'),
          ),
          SizedBox(height: 20),

          // Display the user's name
          Text(
            requestList![0]['name'],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          // Display the user's email address
          Text(
            requestList![0]['email'],
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),

          // Display the user's phone number
          

          // Display the user's address
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Address'),
            subtitle: Text(requestList![0]['address']),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone Number'),
            subtitle: Text(requestList![0]['phone']),
          ),
        ],
      ),
    );
  }
  Future getUserId() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userID');
    requestList = await supabase
        .from('users')
        .select()
        .match({'id': userId});
    setState(() {
      isLoading = false;
    });
    

  }
}