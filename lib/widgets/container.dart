import 'package:flutter/material.dart';
import 'package:newapp/widgets/login.dart';
import 'package:newapp/widgets/report.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puppy Rescue"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      drawer: Drawer(
        child:ListView(padding:EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('Report'),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LocationAndImageForm()),
  );

            },
          ),
          ListTile(
            title: const Text("Sign In"),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
    );

            },
          )
          ], 
          ) ,
          ),
      
      body: SingleChildScrollView(child:  Center(
        child: Column(
          children: [
            Text(
              "Welcome to Puppy Rescue!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Find your new furry friend today!",
              style: TextStyle(fontSize: 16),
            ),
            Image.asset(
              "images/pupp.jpg",
              fit: BoxFit.fitWidth,
            )
          ],
        ),
      ),
      )
    );
  }
}
