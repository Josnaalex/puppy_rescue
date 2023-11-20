import 'package:flutter/material.dart';
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
  final puppy_list = Supabase.instance.client.from('adoption').stream(primaryKey: ['id']).order('id');

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
              

            },
          ),
          ListTile(
            title: const Text("Adopt"),
            onTap: (){

            }
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
                    print(puppyList);
                    return ListView.builder(
                      itemCount: puppyList.length,
                      itemBuilder: (context,index){
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ListTile(
                            title: Text(
                              puppyList[index]['breed'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Age: ${puppyList[index]['age']}'),

                                Text('At Shelter: ${puppyList[index]['shelter_name']}'),
                                Text('Location: ${puppyList[index]['shelter_location']}')
                              ],
                            ),
                            trailing: SizedBox(
                              height: 40,
                              width: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(padding: EdgeInsets.all(5.0),
                                child: GestureDetector(onTap: (){
                                  Navigator.pushNamed(context, '/adopt');
                                }),
                                ),
                              ),
                            ),
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
      // Center(
      //   child: isLoading? Text(''):Text(userId.toString()),
      // ),
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
// class CardExample extends StatelessWidget {
//   const CardExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const ListTile(
//               leading: Icon(Icons.album),
//               title: Text('Puppy 1'),
//               subtitle: Text('At Animal Shelter'),
//             ),
            
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 TextButton(
//                   child: const Text('ADOPT'),
//                   onPressed: () {/* ... */},
//                 ),
//                 const SizedBox(width: 8),
                
                
                
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }