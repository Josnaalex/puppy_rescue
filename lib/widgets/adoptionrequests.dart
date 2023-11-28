import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final supabase = Supabase.instance.client;

class AdoptionRequests extends StatefulWidget {
  const AdoptionRequests({super.key});

  @override
  State<AdoptionRequests> createState() => _AdoptionRequestsState();
}

class _AdoptionRequestsState extends State<AdoptionRequests> {
  dynamic requestList;
  bool isLoading = false;
  dynamic adoptionId;
  dynamic requestedUser;
  dynamic userDetails;
  dynamic puppyDetails;
  dynamic userName;
  dynamic userAddress;
  dynamic puppyBreed;
  dynamic puppyAge;
  bool acceptClicked = false;
  bool declineClicked = false;
  @override
  void initState() {
    super.initState();
    getUserId();
  }
  void acceptRequest() async{
    setState(() {
      acceptClicked = true;
    });
    final response = await supabase
          .from('adoption_requests')
          .update({'status': 'accepted'})
          .match({'id':requestList[0]['id']});
    // await supabase
    //     .from('adoption')
    //     .delete()
    //     .match({'id':adoptionId});

    
      print('Request Accepted');
    
    }
  void declineRequest() async{
    setState(() {
      declineClicked = true;
    });
    final response = await supabase
          .from('adoption_requests')
          .update({'status': 'rejected'})
          .match({'id':requestList[0]['id']});
      print('Request declined');
    
  }
  //display details of requested user and adoptionId and add buttons confirm or reject,give corresponding msgs to the user when button pressed

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

                //give listview here
                 Center(
                    child:Padding(padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:ListView.builder(
                                  itemCount: requestList?.length,
                                  itemBuilder: (context,index){
                                    userName = userDetails?[index]['name'] ?? "";
                                    userAddress = userDetails?[index]['address'] ?? "";
                                    puppyBreed = puppyDetails?[index]['breed'] ?? "";
                                    puppyAge = puppyDetails?[index]['age'] ?? "";


                                    return Container(
                                      margin: EdgeInsets.all(8.0),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: ListTile(
                            title: Text(
                              userName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userAddress),
                                Text(puppyBreed),
                                Text(puppyAge),
                                // Text('Location: ${reportList?[index]['shelter_location']}')
                              ],
                            ),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min, // Adjust spacing between buttons
                                children: [
                                  ElevatedButton(
                                    child: Text('Accept'),
                                    onPressed: () {
                                      // Implement accept request logic
                                      acceptClicked ? null : acceptRequest();

                                    },
                                  ),
                                  SizedBox(width: 8.0), // Add some spacing between buttons
                                  ElevatedButton(
                                    child: Text('Decline'),
                                    onPressed: () {
                                      // Implement decline request logic
                                      declineClicked ? null : declineRequest();
                                    },
                                  ),
                                ],
                                                      
                              )
                                      // child: Column(
                                      //   children: [
                                      //     Text(userName),
                                      //     Text(userAddress),
                                      //   ],
                                      // ),
                            // Text('List will be displayed')
                            )
                          );
                        }
                      )
                    ),
                            
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
        .match({'shelter_id': userId,})
        .neq('status', 'accepted');

    print(requestList);
    if (requestList.length != 0) {
      adoptionId = requestList[0]['adoption_id'];
      requestedUser = requestList[0]['user_id'];
    
      userDetails = await supabase
          .from('users')
          .select('name,address')
          .match({'id': requestedUser});
      puppyDetails = await supabase
          .from('adoption')
          .select('breed,age')
          .match({'id': adoptionId});
    }
    setState(() {
        isLoading = false;
      });
  }
}
