import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;
class RequestStatus extends StatefulWidget {
  const RequestStatus({super.key});

  @override
  State<RequestStatus> createState() => _RequestStatusState();
}

class _RequestStatusState extends State<RequestStatus> {
  bool isLoading = false;
  dynamic requestList;
  dynamic adoptionId;
  dynamic puppyDetails = [];
  dynamic puppyBreed;
  dynamic puppyAge;
  dynamic status;
  @override
  void initState() {
    super.initState();
    getUserId();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adoption Requests"),
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
                    "No adoption requests",
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
                                  itemCount: requestList.length,
                                  itemBuilder: (context,index){
                                    
                                    puppyBreed = puppyDetails?[index]['breed'] ?? "";
                                    puppyAge = puppyDetails?[index]['age'] ?? "";
                                    status = requestList?[index]['status'] ?? "";


                                    return Container(
                                      margin: EdgeInsets.all(8.0),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: ListTile(
                            title: Text(
                              puppyBreed,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(puppyAge),
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
        .from('adoption_requests')
        .select()
        .match({'user_id': userId});
    if (requestList.length != 0) {
      // adoptionId = requestList[0]['adoption_id'];

      for (var i = 0; i < requestList.length; i++) {
        adoptionId = requestList[i]['adoption_id'];
        dynamic temp;

        temp = await supabase
        .from('adoption')
        .select('breed,age')
        .match({'id': adoptionId});

        puppyDetails = puppyDetails + temp;
      }
    }

    
    // puppyDetails = await supabase
    //     .from('adoption')
    //     .select('breed,age')
    //     .match({'id': adoptionId});
    setState(() {
      isLoading = false;
    });
    

  }

}