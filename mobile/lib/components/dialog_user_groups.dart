import 'package:flutter/material.dart';
import '../models/group.dart';
import 'package:meta/meta.dart';

class DialogUserGroups extends StatefulWidget {
  final Function(int index, bool val) onChecked;
  final List<Group> groups;
  final VoidCallback onCloseDialog;

  DialogUserGroups(
      {this.onChecked, @required this.groups, @required this.onCloseDialog});

  @override
  State<StatefulWidget> createState() =>
      new _DialogState(this.onChecked, this.groups, this.onCloseDialog);
}

class _DialogState extends State<DialogUserGroups> {
  List<Group> _groups;
  Function(int index, bool val) _onChecked;
  final VoidCallback _onCloseDialog;

  _DialogState(this._onChecked, this._groups, this._onCloseDialog);

  @override
  Widget build(BuildContext context) {
    List<Widget> childrens = List.generate(_groups.length, (index) {
      return CheckboxListTile(
        title: Text(_groups[index].name),
        value: _groups[index].checked,
        onChanged: (bool val) {
          _onChecked(index, val);
          setState(() {
            _groups[index].checked = val;
          });
        },
      );
    });

    childrens.add(Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: RaisedButton(
          onPressed: _onCloseDialog,
          color: Colors.blueAccent,
          textColor: Colors.white,
          child: Text("Simpan Group"),
        )));

    return Dialog(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: childrens,
        ),
      ),
    );
  }
}
