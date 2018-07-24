import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class NotificationComponent extends StatefulWidget {

  bool isDisplayed;

  VoidCallback callback;

  NotificationComponent({@required this.isDisplayed});

  @override
  State<StatefulWidget> createState() => new _NotificationComponentState(this.isDisplayed);
}

class _NotificationComponentState extends State<NotificationComponent> {

  bool _isDisplayed;

  VoidCallback _callback;

  _NotificationComponentState(this._isDisplayed);

  @override
  Widget build(BuildContext context) {

  }
}
