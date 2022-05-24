import 'package:flutter/material.dart';

class Testy extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Sheet guide',
      home: HomeView(),
    );
  }
}
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( body: Builder(
      builder: (context) => Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                showBottomSheet(
                    context: context,
                    builder: (context) => Container(
                          color: Colors.red,
                        ));
              },
            ),
          ),
    ));
  }
}