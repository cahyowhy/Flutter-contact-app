import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class NotificationComponent extends StatefulWidget {
  final String title;
  final VoidCallback callback;

  NotificationComponent({@required this.title, this.callback});

  @override
  State<StatefulWidget> createState() =>
      new _NotificationComponentState(this.title, this.callback);
}

class _NotificationComponentState extends State<NotificationComponent> {
  String _title;
  VoidCallback _callback;

  _NotificationComponentState(this._title,this._callback);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Colors.blueAccent,
                padding:
                EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(_title,
                              style: TextStyle(color: Colors.white)),
                        ),
                        IconButton(
                            icon: Icon(Icons.clear),
                            color: Colors.white,
                            onPressed: () {
                              debugPrint("delete");
                            })
                      ],
                    ),
                    RaisedButton(
                        child: Text("Kembali ke awal"),
                        color: Colors.amberAccent,
                        onPressed: _callback)
                  ],
                ),
              )
            ]));
  }
}
