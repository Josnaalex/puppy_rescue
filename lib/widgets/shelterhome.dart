import 'package:flutter/material.dart';
import 'package:newapp/widgets/addpuppy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShelterHome extends StatefulWidget {
  const ShelterHome({super.key});

  @override
  State<ShelterHome> createState() => _ShelterHomeState();
}

class _ShelterHomeState extends State<ShelterHome> {
   dynamic userId;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puppy Rescue"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      drawer: Drawer(
        child:ListView(
          padding:EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text(""),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/drawer.jpg'),
                fit: BoxFit.cover
                )
            ),
            ),
            ListTile(
            title: const Text("Reports"),
            onTap: (){

            }
          ),
          ListTile(
            title: const Text("Adoption Requests"),
            onTap: (){

            }
          ),
           ListTile(
            title: const Text("Sign Out"),
            onTap: ()async{
               
            final prefs = await SharedPreferences.getInstance();

              await prefs.remove('userID');

                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          ),
          ListTile(
            title: const Text("Add Puppy"),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPuppy()),
              );
            }
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