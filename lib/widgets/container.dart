import 'package:flutter/material.dart';
import 'package:newapp/widgets/adminlogin.dart';
import 'package:newapp/widgets/login.dart';
import 'package:newapp/widgets/shelterlogin.dart';

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
        child:ListView(
          padding:EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Menu"),
            accountEmail: Text(""),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/drawer.jpg'),
                fit: BoxFit.cover
                )
            ),
            ),
          
          ListTile(
            title: const Text("Sign In as User"),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
    );

            },
          ),
          ListTile(
            title: const Text("Sign In as Animal Shelter"),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInShelter()),
    );
    

            },
          ),
          ListTile(
            title: const Text("Sign In as Admin"),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInAdmin()),
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
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Find your new furry friend today!",
              style: TextStyle(fontSize: 22),
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
