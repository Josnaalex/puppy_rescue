import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


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
  dynamic puppyDetails = [];
  dynamic userDetails = [];
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
      getUserId();
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
      getUserId();
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
                                    onPressed: () async{
                                      // Implement accept request logic
                                      acceptClicked ? null : acceptRequest();
                                      final response = await supabase.from('users').select('onesignaluserid').match({
                                        'id':requestList[0]['user_id']
                                      });

                                      const message = "Your adoption request has been accepted";

                                      sendPushNotification(response[0]['onesignaluserid'], message);

                                    },
                                  ),
                                  SizedBox(width: 8.0), // Add some spacing between buttons
                                  ElevatedButton(
                                    child: Text('Decline'),
                                    onPressed: () async{
                                      // Implement decline request logic
                                      declineClicked ? null : declineRequest();
                                      final response = await supabase.from('users').select('onesignaluserid').match({
                                        'id':requestList[0]['user_id']
                                      });

                                      const message = "Your adoption request has been rejected";

                                      sendPushNotification(response[0]['onesignaluserid'], message);
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

  Future sendPushNotification(String userId, String message) async {

    await dotenv.load(fileName: ".env");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': dotenv.env['URL']!,
    };

    var body = {
      'app_id': dotenv.env['APP_ID']!,
      'include_player_ids': [userId],
      'contents': {'en': message},
    };

    await http.post(
      Uri.parse("https://onesignal.com/api/v1/notifications"),
      headers: headers,
      body: jsonEncode(body),
    );

  }

  Future getUserId() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userID');
    print(userId);
    requestList = await supabase
        .from('adoption_requests')
        .select()
        .match({'shelter_id': userId, 'status': 'pending'});

    if (requestList.length != 0) {
      for (var i = 0; i < requestList.length; i++) {
        dynamic temp1;
        dynamic temp2;

        temp1 = await supabase
          .from('users')
          .select('name,address')
          .match({'id': requestList[i]['user_id']});
        temp2 = await supabase
        .from('adoption')
        .select('breed,age')
        .match({'id': requestList[i]['adoption_id']});



        
        userDetails = userDetails + temp1;
        puppyDetails = puppyDetails + temp2;

      }
      print(userDetails);
      print(puppyDetails);
    }
    setState(() {
        isLoading = false;
      });
  }
}
