import 'package:flutter/material.dart';
import 'package:waste_mangement/cards/cards_home.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Business',
      style: optionStyle,
    ),
    Text(
      'School',
      style: optionStyle,
    ),
    Text(
      'Account',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var myList = ["afdkashfhkadsjdfdfhla", "b", "c","d","j","k","l","m","n","o","p"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _widgetOptions.elementAt(_selectedIndex)),
      body: ListView(children: <Widget>[
        // _widgetOptions.elementAt(_selectedIndex),
        GridView.count(
          mainAxisSpacing: 1.0,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(myList.length-7, (index) {
            return CardsHome(
              title: myList[index],
              subtitle: myList[index],
            );
          }),
        ),
        // SizedBox(
        //   height: 200.0,
        //   width: 300.0,
        //   child: ListView.builder(
        //     scrollDirection: Axis.vertical,
        //     itemCount: myList.length,
        //     itemBuilder: (context, index) {
        //       return CardsHome(
        //         title: myList[index],
        //         subtitle: myList[index],
        //       );
        //     },
        //   ),
        // ),
        ...myList.map((e) => CardsHome(
              title: e,
              subtitle: e,
            ))
      ]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Account'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
