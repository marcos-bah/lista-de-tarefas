import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Casa extends StatefulWidget {
  @override
  CasaState createState() => CasaState();
}

class CasaState extends State<Casa> {
  final _toDoController = TextEditingController();

  List _toDoList1 = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _toDoList1.clear();
        _toDoList1 = json.decode(data);
      });
    });
  }

  void _addToDo() {
    setState(
      () {
        Map<String, dynamic> newToDo = Map();
        newToDo["title"] = _toDoController.text;
        _toDoController.text = "";
        newToDo["ok"] = false;
        _toDoList1.add(newToDo);
        _saveData();
      },
    );
  }

  Future<Null> _reflesh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList1.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });
      _saveData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                ),
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _reflesh,
            child: ListView.builder(
              itemBuilder: buildItem,
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _toDoList1.length,
            ),
          )),
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList1[index]['title']),
        value: _toDoList1[index]['ok'],
        secondary: CircleAvatar(
          child: Icon(_toDoList1[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _toDoList1[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList1[index]);
          _lastRemovedPos = index;
          _toDoList1.removeAt(index);
          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _toDoList1.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/data0.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList1);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print("Erro");
      return null;
    }
  }
}
