import 'package:flutter/material.dart';
import 'package:thesis/models/User.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';

class DEUserScreen extends StatefulWidget {
  static const routeName = '/user';

  @override
  State<StatefulWidget> createState() {
    return DEUserScreenState();
  }
}

class DEUserScreenState extends State<DEUserScreen> {
  bool _enableEditting = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _dineEasyRepository = DineEasyRepository();
    return Scaffold(
        appBar: AppBar(
          title: Text("User info"),
        ),
        bottomNavigationBar: DEBottomNavigationBar(2),
        body: FutureBuilder(
            future: _dineEasyRepository.getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                User user = snapshot.data as User;
                _nameController.text = user.name;
                _phoneNrController.text = user.phoneNr;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Card(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                enabled: _enableEditting,
                                controller: _nameController,
                                decoration: InputDecoration(labelText: "Name"),
                              ))),
                      Card(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                enabled: _enableEditting,
                                controller: _phoneNrController,
                                decoration:
                                    InputDecoration(labelText: "Phone Number"),
                              ))),
                      FlatButton(
                        child: Text(_enableEditting ? "Save" : "Edit"),
                        onPressed: () async {
                          User u = User(
                              id: user.id,
                              name: _nameController.text,
                              phoneNr: _phoneNrController.text);
                          await _dineEasyRepository.updateUser(u);
                          setState(() {
                            user = u;
                            _enableEditting = !_enableEditting;
                          });
                        },
                      )
                    ],
                  ),
                );
              }
              return Center(child: const CircularProgressIndicator());
            }));
  }
}
