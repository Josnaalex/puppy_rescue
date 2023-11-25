import 'package:flutter/material.dart';
import 'package:newapp/widgets/adopt.dart';
import 'package:newapp/widgets/adoptionrequests.dart';
import 'package:newapp/widgets/shelterhome.dart';
import 'package:newapp/widgets/shelterlogin.dart';
import 'package:newapp/widgets/userhome.dart';
import 'package:newapp/widgets/viewreportedpuppy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newapp/widgets/container.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://azhhmgrywphfdssxwzym.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF6aGhtZ3J5d3BoZmRzc3h3enltIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTc1NDM5OTMsImV4cCI6MjAxMzExOTk5M30.SU1HK1ttcYIlchuxGl7tmI31_R9NZQTWACnVqGEjhEQ'
  );
  runApp(MyApp());
}
// void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter demo",
      initialRoute: '/',
      routes: {
        '/' : (context) => const MyWidget(),
        '/userhome' : (context) => const UserHome(),
        '/adopt' : (context) => const AdoptPuppy(),
        '/shelterlogin' : (context) => const SignInShelter(),
        '/shelterhome' : (context) => const ShelterHome(),
        '/viewpuppy' : (context) => const ViewPuppy(),
        '/adoptionrequests' : (context) => const AdoptionRequests(),
      }
    );
  }
}

// class MyForm extends StatelessWidget {
//   MyForm({ Key? key }) : super(key: key);

//   final TextEditingController textFieldController = TextEditingController();


//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "My Form ",
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("MyForm"),
//           backgroundColor: Colors.deepOrange,
//         ),
//       body:Column(
//         children: [
//           TextField(
//             controller: textFieldController,
//             decoration: InputDecoration(
//               labelText: "Name"
//             ),
//           ),
//           ElevatedButton(onPressed: () async {
//               String value = textFieldController.text;
//               await Supabase.instance.client.from('names').insert({'name':value});
//           } , child:Text("submit"))
//         ],
//       ) ,
//       )
//     );
//   }
// }