import 'package:flutter/material.dart';
import 'package:newapp/widgets/admin_viewpuppy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final client = Supabase.instance.client;
class ShelterApproval extends StatefulWidget {
  const ShelterApproval({super.key});

  @override
  State<ShelterApproval> createState() => _ShelterApprovalState();
}

class _ShelterApprovalState extends State<ShelterApproval> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Approvals'),
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
                  title: const Text("Approve/Reject Shelter Registrations"),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ViewReports()),
                    // );
                  }),
              ListTile(title: const Text("View Reports"), onTap: () {
                Navigator.pushNamed(context, '/adminviewreports');
              }),
              
              ListTile(
                  title: const Text("View Puppies for Adoption"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminViewPuppy()),
                    );
                  }),
            ],
          ),
        ),
    body: FutureBuilder(
  future: client.from('pending_approval').select(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
        var registrations = snapshot.data as List; // Access the data property

      if (registrations != null && registrations is List) {
        return ListView.builder(
          itemCount: registrations.length,
          itemBuilder: (context, index) {
            var registration = registrations[index];
            return ListTile(
              title: Text(registration['shelter_name']),
              subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(registration['location']),
                                Text(registration['email']),
                                Text(registration['license_no']),
                                // Text('Location: ${reportList?[index]['shelter_location']}')
                              ],
                            ),
              
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      // Implement approveRegistration using registration['id']
                      var registrationId = registration['id'];

                      // Move the registration data to the approved table (assuming 'approved_registrations')
                      client.from('shelters').insert({
                        'name': registration['shelter_name'],
                        'location': registration['location'],
                        'email': registration['email'],
                        'password': registration['password'],
                        'phone': registration['phone'],

                      }).then((value) {
                        // After successful insertion into approved table, delete from pending_approval
                        // 
                         client.from('pending_approval').delete().eq('id', registrationId).execute().then((_) {
                  setState(() {
                    registrations.removeAt(index); // Remove the item from the list
                  });
                      }).catchError((error) {
                        print('Error approving registration: $error');
                        // Handle error scenario
                      });
                    });},
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      // Implement rejectRegistration using registration['id']
                       var registrationId = registration['id'];

                      // Delete the registration from the pending_approval table
                      // client.from('pending_approval').delete().eq('id', registrationId).execute().catchError((error) {
                      //   print('Error rejecting registration: $error');
                        // Handle error scenario
                         client.from('pending_approval').delete().eq('id', registrationId).execute().then((_) {
                setState(() {
                  registrations.removeAt(index); // Remove the item from the list
                });
                        });
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return Text('No pending registrations');
      }
    }
  },
),

    );
  }
  }
