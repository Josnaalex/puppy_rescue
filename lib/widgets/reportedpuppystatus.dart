import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;
class ReportStatus extends StatefulWidget {
  const ReportStatus({super.key});

  @override
  State<ReportStatus> createState() => _ReportStatusState();
}

class _ReportStatusState extends State<ReportStatus> {
  bool isLoading = false;
  dynamic requestList;
  dynamic adoptionId;
  dynamic puppyDetails;
  dynamic status;
  dynamic location;
  @override
  void initState() {
    super.initState();
    getUserId();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reported Puppy Status"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
        body: isLoading
            ? Center(
                child: Text(
                "Loading...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))
            : requestList.length == 0
                ? Center(
                    child: Text(
                    "No reports",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ))
            :
            Center(
                    child:Padding(padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:ListView.builder(
                                  itemCount: requestList?.length,
                                  itemBuilder: (context,index){
                                    
                                    location = requestList?[index]['location'] ?? "";

                                    status = requestList?[index]['status'] ?? "";


                                    return Container(
                                      margin: EdgeInsets.all(8.0),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: ListTile(
                            
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Puppy spotted at : $location'),
                                Text(status),
                                // Text('Location: ${reportList?[index]['shelter_location']}')
                              ],
                            ),
                          
                          
                                      )
                                    );
                                  }
                                  )
                        )
                      ]
                    )
                    )
            )

    );
  }
  Future getUserId() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userID');
    requestList = await supabase
        .from('reports')
        .select()
        .match({'user_id': userId});
    if (requestList.length != 0) {
      adoptionId = requestList[0]['location'];
    }
    
    
    setState(() {
      isLoading = false;
    });
    

  }

}