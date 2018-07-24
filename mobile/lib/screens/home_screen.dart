import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<HomeScreen> {
  List<User> _users = [];
  Map _paramGet = {"offset": 0, "limit": 9, "user_name": ""};
  ScrollController scrollController = new ScrollController();
  TextEditingController textController = new TextEditingController();
  bool _isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    _doFindUsers();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          _paramGet["offset"] = _paramGet["limit"] + _paramGet["offset"];
        });

        _doFindUsers();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void _doFindUsers() async {
    setState(() {
      _isPerformingRequest = true;
    });

    List<User> users = await UserService.instance.fetchAll(_paramGet);

    setState(() {
      _users.addAll(users);
      _isPerformingRequest = false;
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

  Widget _buildLoadIndicator() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
          child: Opacity(
        opacity: _isPerformingRequest ? 1.0 : 0.0,
        child: CircularProgressIndicator(),
      )),
    );
  }

  Widget _buildListItem(User user, int index) {
    return Builder(builder: (BuildContext context) {
      return Dismissible(
          key: Key("list-" + user.name + user.id.toString()),
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

  void _resetSearch() {
    setState(() {
      _paramGet["offset"] = 0;
      _users = [];
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
                                  controller: textController,
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
                                            _resetSearch();
                                            setState(() {
                                              _paramGet["user_name"] =
                                                  textController.text;
                                            });

                                            _doFindUsers();
                                            textController.clear();
                                          }))))
                        ],
                      ))),
            ),
            Flexible(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.only(top: 16.0),
                    child: ListView(
                      controller: scrollController,
                      children: List.generate(_users.length + 1, (index) {
                        if (index == _users.length) {
                          return _buildLoadIndicator();
                        }

                        return _buildListItem(_users[index], index);
                      }),
                    )))
          ],
        )));
  }
}
