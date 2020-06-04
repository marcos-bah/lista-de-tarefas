import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/src/casa.dart';
import 'package:lista_de_tarefas/src/esportes.dart';
import 'package:lista_de_tarefas/src/pessoal.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Casa(),
    Esportes(),
    Pessoal(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Casa'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.directions_bike),
            title: new Text('Esportes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Pessoais'),
          ),
        ],
      ),
    );
  }
}
