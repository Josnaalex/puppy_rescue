import 'package:flutter/material.dart';
class ShelterHome extends StatefulWidget {
  const ShelterHome({super.key});

  @override
  State<ShelterHome> createState() => _ShelterHomeState();
}

class _ShelterHomeState extends State<ShelterHome> {
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
            title: const Text("Add Puppy"),
            onTap: (){

            }
          ),
        ],
        ),
      ),
      
    );
  }
}