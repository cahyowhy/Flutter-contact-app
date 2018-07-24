import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<HomeScreen> {
  List<User> _users = [];
  Map _paramGet = {"offset": 0, "limit": 9};
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _doFindUsers();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }

  void _scrollListener() {
    debugPrint(scrollController.position.extentAfter.toString());
    if (scrollController.position.extentAfter < 500) {
      debugPrint('check');
    }
  }

  void _doFindUsers() {
    UserService.instance.fetchAll(_paramGet).then((List<User> users) {
      setState(() {
        _users = users;
      });
    });
  }

  void _doDeleteUser(User user, context) {
    UserService.instance.remove(user.id).then((response) {
      String status =
          response['status'].toString() == '210' ? 'Berhasil' : 'Gagal';
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("${status} Menghapus ${user.name} dari kontak")));
    });
  }

  Widget _buildListItem(User user, int index) {

    return Builder(builder: (BuildContext context) {
      return Dismissible(
          key: Key("list-" + index.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (DismissDirection dismissDirection) {
            setState(() {
              _users.removeAt(index);
            });

            _doDeleteUser(user, context);
          },
          background: Container(
              color: Colors.redAccent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(child: SizedBox(), flex: 1),
                  Container(
                      child: Icon(Icons.delete_sweep, color: Colors.white),
                      padding: EdgeInsets.symmetric(horizontal: 16.0))
                ],
              )),
          child: ListTile(
              leading: Image.network(user.image_profile),
              title: Text(user.name + " " + user.surname),
              subtitle: Text(user.address),
              trailing: Icon(Icons.remove_circle)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Contact app')),
        body: Container(
            child: Column(
          children: <Widget>[
            Flexible(
              flex: 0,
              child: Material(
                  elevation: 2.0,
                  child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              flex: 1,
                              child: TextField(
                                  decoration: InputDecoration(
                                      hintText: 'Masukkan nama user',
                                      border: InputBorder.none))),
                          Flexible(
                              flex: 0,
                              child: Container(
                                  margin: EdgeInsets.only(left: 16.0),
                                  child: SizedBox(
                                      width: 55.0,
                                      child: RaisedButton(
                                          padding: EdgeInsets.all(2.0),
                                          child: Icon(Icons.search,
                                              color: Colors.white),
                                          color: Colors.blueAccent,
                                          onPressed: () {
                                            print("check");
                                          }))))
                        ],
                      ))),
            ),
            Flexible(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: ListView(
                      controller: scrollController,
                      children: List.generate(_users.length, (index) {
                        return _buildListItem(_users[index], index);
                      }),
                    )))
          ],
        )));
  }
}
