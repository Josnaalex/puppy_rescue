import 'package:flutter/material.dart';
import 'package:newapp/widgets/addpuppy.dart';
import 'package:newapp/widgets/viewreports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShelterHome extends StatefulWidget {
  const ShelterHome({super.key});

  @override
  State<ShelterHome> createState() => _ShelterHomeState();
}

class _ShelterHomeState extends State<ShelterHome> {
  dynamic reportList;
  dynamic location = "";
  dynamic landmark = "";
  dynamic userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Puppy Rescue"),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(""),
                accountEmail: Text(""),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/drawer.jpg'),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                  title: const Text("Reports"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewReports()),
                    );
                  }),
              ListTile(title: const Text("Adoption Requests"), onTap: () {
                Navigator.pushNamed(context, '/adoptionrequests');
              }),
              
              ListTile(
                  title: const Text("Add Puppy"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPuppy()),
                    );
                  }),
                  ListTile(
                  title: const Text("Sign Out"),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();

                    await prefs.remove('userID');

                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  }),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading?Text(''): Expanded(
                    child: ListView.builder(
                        itemCount: reportList?.length,
                        itemBuilder: (context, index) {
                          location = reportList?[index]['location'] ?? "";
                          landmark = reportList?[index]['landmark'] ?? "";
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: ListTile(
                                title: Text(
                                  location,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(location),

                                    Text(landmark),
                                    // Text('Location: ${reportList?[index]['shelter_location']}')
                                  ],
                                ),
                                trailing: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/viewpuppy',
                                          arguments: {
                                            'reportId': reportList[index]['id'],
                                          });
                                    },
                                    child: Text('View'))),
                          );
                        }))
              ],
            ),
          ),
        ));
  }

  Future getUserId() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userID');  
     reportList = await Supabase.instance.client
      .from('reports')
      .select('id,location, landmark')
      .match({'shelter_id' : userId});
      print(reportList);
    setState(() {
      isLoading = false;
    });
  }
}
