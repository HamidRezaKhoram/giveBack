import 'package:flutter/material.dart';

class CardsHome extends StatelessWidget {
  const CardsHome({Key? key, required this.title, required this.subtitle})
      : super(key: key);
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return _CardsHomeState(title: title, subtitle: subtitle);
  }
}

class _CardsHomeState extends StatelessWidget {
  const _CardsHomeState({Key? key, required this.title, required this.subtitle})
      : super(key: key);
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    // return Container(
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(15),
    //       image: const DecorationImage(
    //           image: NetworkImage(
    //               "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
    //           fit: BoxFit.cover),
    //     ),
    //     child:
    return Card(

        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.blueAccent),
        //   borderRadius: BorderRadius.circular(10),
        // ),

        margin: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.album_sharp),
                title: Text(title),
                subtitle: Text(subtitle),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                TextButton(
                  child: const Text("Approve"),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text("Decline"),
                  onPressed: () {},
                )
              ])
            ]));
  }
}
