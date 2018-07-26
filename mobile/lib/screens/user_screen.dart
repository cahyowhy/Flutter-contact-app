import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import '../utils/network_image_retry.dart';

import '../models/user.dart';

class UserScreen extends StatefulWidget {
  User user;

  UserScreen({@required this.user});

  @override
  State<StatefulWidget> createState() => new _UserState(user);
}

class _UserState extends State<UserScreen> {
  User _user;

  _UserState(this._user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Kontak ${_user.name}")),
        body: Container(
          padding: EdgeInsets.only(right: 16.0, left: 16.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image(
                          image: NetworkImageWithRetry(_user.image_profile),
                          height: 100.0,
                          width: 100.0),
                      Text("${_user.name} ${_user.surname}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.message),
                              onPressed: () {
                                debugPrint("check");
                              }),
                          IconButton(
                              icon: Icon(Icons.call),
                              onPressed: () {
                                debugPrint("check");
                              }),
                        ],
                      )
                    ],
                  )),
                  Container(
                      child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Nama",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        onChanged: (String nama) {
                          setState(() {
                            _user.name = nama;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Nama Belakang",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        onChanged: (String surname) {
                          setState(() {
                            _user.surname = surname;
                          });
                        },
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            labelText: "About",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        onChanged: (String about) {
                          setState(() {
                            _user.about = about;
                          });
                        },
                      ),
                    ],
                  ))
                ],
              )
            ],
          ),
        ));
  }
}
