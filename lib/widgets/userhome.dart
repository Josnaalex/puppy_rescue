import 'package:flutter/material.dart';
import 'package:newapp/widgets/reportandprogress.dart';
import 'package:newapp/widgets/reportedpuppystatus.dart';
import 'package:newapp/widgets/requeststatus.dart';
import 'package:newapp/widgets/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}


class _UserHomeState extends State<UserHome> {

  dynamic userId;
  bool isLoading = false;
  final supabase = Supabase.instance.client;
  // ignore: non_constant_identifier_names
  final puppy_list = Supabase.instance.client.from('adoption').stream(primaryKey: ['id']).eq('status', false ).order('id');

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adopt your Puppy"),
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
            title: const Text('Report'),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportAndProgress()),
  );

            },
          ),
          ListTile(
            title: const Text("Adopt"),
            onTap: (){
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>UserHome()),
  );
            }
          ),
           ListTile(
            title: const Text('View Adoption Status'),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequestStatus()),
  );

            },
          ),
          ListTile(
            title: const Text('View Reported Puppy Status'),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportStatus()),
  );

            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfile()),
  );

            },
          ),
          ListTile(
            title: const Text("Sign Out"),
            onTap : ()async{
            final prefs = await SharedPreferences.getInstance();

              await prefs.remove('userID');

                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          )
        ]
        )
      ),
      body: Center(
        child:Padding(padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child:StreamBuilder(
                stream: puppy_list,
                builder: (context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    final puppyList = snapshot.data;
                    // print(puppyList);
                    return ListView.builder(
                      itemCount: puppyList.length,
                      itemBuilder: (context,index){
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12,width: 5.0),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ListTile(
                            title: Text(
                              'Breed: ${puppyList[index]['breed']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Age: ${puppyList[index]['age']}'),

                                Text('At: ${puppyList[index]['shelter_name']}'),
                                Text('Location: ${puppyList[index]['shelter_location']}')
                              ],
                            ),
                            trailing: ElevatedButton(onPressed:() {
                                  Navigator.pushNamed(context, '/adopt', arguments: {
                                    'adoptionId':puppyList[index]['id'],
                                    'shelterId' :puppyList[index]['shelter_id']
                                  });

                            }, child: Text('Adopt'))
                          ),
                        );
                      }
                    );
                  }
                  return Container();
                },
              ) )
          ],
        ),

        ),
        )
      
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
