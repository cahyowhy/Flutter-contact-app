import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/network_image_retry.dart';

import '../services/user_service.dart';
import '../services/group_service.dart';
import '../services/user_group_service.dart';

import '../models/user.dart';
import '../models/group.dart';
import '../models/contact.dart';
import '../models/user_group.dart';
import '../models/phone_number.dart';

class UserScreen extends StatefulWidget {
  User user;

  UserScreen({@required this.user});

  @override
  State<StatefulWidget> createState() => new _UserState(user);
}

class _UserState extends State<UserScreen> {
  User _user = new User('', '', '', '', '');
  List<Group> _groups = [];
  List<UserGroup> _userGroups = [];
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _UserState(this._user);

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<Null> _initData() async {
    await _doFindUser();
    await _doFetchUserGroups();
    await _doFetchGroups();
  }

  Future<Null> _doFindUser() async {
    User user = await UserService.instance.fetch(_user.id.toString());

    setState(() {
      _user = user;
    });
  }

  Future<Null> _doFetchGroups() async {
    List<Group> groups = await GroupService.instance.fetchAll();

    setState(() {
      _groups = groups.map((Group group) {
        bool hasUserGroup = _userGroups.fold(
            false, (accu, item) => accu || item.group.id == group.id);
        group.checked = hasUserGroup;

        return group;
      }).toList();
    });
  }

  Future<Null> _doFetchUserGroups() async {
    List<UserGroup> userGroups =
        await UserGroupService.instance.fetch(_user.id);

    setState(() {
      _userGroups = userGroups;
    });
  }

  void _onSubmitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  void _doSaveGroup() {
    List<UserGroup> checkedGroups = _userGroups;
    checkedGroups
      ..addAll(_groups.where((Group group) => group.checked).map((Group group) {
        UserGroup userGroup = new UserGroup();
        userGroup.user = _user;
        userGroup.group = group;

        return userGroup;
      }).toList());

    Future.wait(checkedGroups.map((UserGroup userGroup) {
      if (userGroup.id != 0) {
        return UserGroupService.instance.remove(userGroup.id);
      }

      return UserGroupService.instance.save(userGroup);
    })).then((List response) {
      print(response);
    });
  }

  Widget _buildContactItems(index) {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(index == 0 ? Icons.add : Icons.delete),
            onPressed: () {
              setState(() {
                if (index == 0) {
                  _user.contacts.add(new Contact());
                } else {
                  _user.contacts.removeAt(index);
                }
              });
            },
          ),
          Container(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(index == 0 ? "Tambah" : "Hapus_."))
        ],
      ),
      Expanded(
          child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: _user.contacts[index].email,
            decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            onSaved: (String email) {
              setState(() {
                _user.contacts[index].email = email;
              });
            },
          ),
          TextFormField(
            initialValue: _user.contacts[index].website,
            decoration: InputDecoration(
                labelText: "website",
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            onSaved: (String website) {
              setState(() {
                _user.contacts[index].website = website;
              });
            },
          ),
          Container(
              child: Column(
                  children: List
                      .generate(_user.contacts[index].phone_numbers.length,
                          (indexPhoneNum) {
            return Row(children: <Widget>[
              IconButton(
                icon: Icon(indexPhoneNum == 0 ? Icons.add : Icons.delete),
                onPressed: () {
                  setState(() {
                    if (indexPhoneNum == 0) {
                      _user.contacts[index].phone_numbers
                          .add(new PhoneNumber(""));
                    } else {
                      _user.contacts[index].phone_numbers
                          .removeAt(indexPhoneNum);
                    }
                  });
                },
              ),
              Flexible(
                  child: TextFormField(
                initialValue: _user
                    .contacts[index].phone_numbers[indexPhoneNum].phone_number,
                validator: _user.contacts[index].phone_numbers[indexPhoneNum]
                    .validatePhoneNumber,
                decoration: InputDecoration(
                    labelText: "nomor telepon",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
                keyboardType: TextInputType.phone,
                onSaved: (String phoneNumber) {
                  setState(() {
                    _user.contacts[index].phone_numbers[indexPhoneNum]
                        .phone_number = phoneNumber;
                  });
                },
              )),
            ]);
          })))
        ],
      ))
    ]);
  }

  Widget _buildCheckboxGroups(BuildContext context) {
    List<Widget> childrens = List.generate(_groups.length, (index) {
      return CheckboxListTile(
        title: Text(_groups[index].name),
        value: _groups[index].checked,
        onChanged: (bool val) {
          setState(() {
            _groups[index].checked = val;
          });
        },
      );
    });

    childrens.add(Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          color: Colors.blueAccent,
          textColor: Colors.white,
          child: Text("Simpan Group"),
        )));

    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: childrens,
    ));
  }

  Future<Null> _showGroupDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) =>
            Dialog(child: _buildCheckboxGroups(dialogContext)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Kontak ${_user.name}")),
        body: Container(
            padding: EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
            child: Form(
              key: _formKey,
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
                              IconButton(
                                  icon: Icon(Icons.group),
                                  onPressed: () async {
                                    await _showGroupDialog(context);
                                  })
                            ],
                          )
                        ],
                      )),
                      Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            initialValue: _user.name,
                            validator: _user.validateName,
                            decoration: InputDecoration(
                                labelText: "Nama",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            onSaved: (String nama) {
                              setState(() {
                                _user.name = nama;
                              });
                            },
                          ),
                          TextFormField(
                            initialValue: _user.surname,
                            decoration: InputDecoration(
                                labelText: "Nama Belakang",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            onSaved: (String surname) {
                              setState(() {
                                _user.surname = surname;
                              });
                            },
                          ),
                          TextFormField(
                            maxLines: 5,
                            initialValue: _user.about,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                labelText: "About",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            onSaved: (String about) {
                              setState(() {
                                _user.about = about;
                              });
                            },
                          ),
                          (_user.contacts ?? []).isEmpty
                              ? SizedBox(width: 0.0, height: 0.0)
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(_user.contacts.length,
                                      (index) => _buildContactItems(index))),
                          Padding(
                              child: RaisedButton(
                                  color: Colors.blueAccent,
                                  textColor: Colors.white,
                                  onPressed: _onSubmitForm,
                                  child: Text("Simpan kontak ${_user.name}")),
                              padding: EdgeInsets.only(top: 12.0))
                        ],
                      ))
                    ],
                  )
                ],
              ),
            )));
  }
}
