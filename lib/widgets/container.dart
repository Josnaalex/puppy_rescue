import 'package:flutter/material.dart';
import 'package:newapp/widgets/login.dart';
import 'package:newapp/widgets/report.dart';
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
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Colors.brown,
          //   ),
          //   child: Text('Menu'),
          // ),
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
