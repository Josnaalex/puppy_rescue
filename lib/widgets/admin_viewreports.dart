import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class AdminViewReports extends StatefulWidget {
  const AdminViewReports({super.key});

  @override
  State<AdminViewReports> createState() => _AdminViewReportsState();
}

class _AdminViewReportsState extends State<AdminViewReports> {
  dynamic reportList;

  dynamic location = "";
  dynamic landmark = "";

  bool isLoading = false;
  final supabase = Supabase.instance.client;
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
      body: Center(
        child:Padding(padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child:ListView.builder(
                      itemCount: reportList?.length,
                      itemBuilder: (context,index){
                        location = reportList?[index]['location'] ?? "";
                        landmark = reportList?[index]['landmark'] ?? "";
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                           
                          ),
                        );
                      }
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
    
    reportList = await Supabase.instance.client
      .from('reports')
      .select();
      print(reportList);
    setState(() {
      isLoading = false;
    });
  }
}
