import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class AdminViewPuppy extends StatefulWidget {
  const AdminViewPuppy({super.key});

  @override
  State<AdminViewPuppy> createState() => _AdminViewPuppyState();
}

class _AdminViewPuppyState extends State<AdminViewPuppy> {
  dynamic userId;
  bool isLoading = false;
  final supabase = Supabase.instance.client;
  // ignore: non_constant_identifier_names
  final puppy_list = Supabase.instance.client.from('adoption').stream(primaryKey: ['id']).eq('status', false ).order('id');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puppy Rescue"),
        centerTitle: true,
        backgroundColor: Colors.brown,
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
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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

                                Text('At Shelter: ${puppyList[index]['shelter_name']}'),
                                Text('Location: ${puppyList[index]['shelter_location']}')
                              ],
                            ),
                            trailing: ElevatedButton(onPressed:() {
                                  Navigator.pushNamed(context, '/adopt', arguments: {
                                    'adoptionId':puppyList[index]['id'],
                                    'shelterId' :puppyList[index]['shelter_id']
                                  });

                            }, child: Text('Puppy Image'))
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
}