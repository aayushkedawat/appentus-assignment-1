import 'dart:convert';
import 'dart:io';

import 'package:assignment_1/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? imageFile;
  String name = '';
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((_) {
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.containsKey('userDetails')) {
          Map<String, dynamic> userDetails =
              jsonDecode(prefs.getString('userDetails') as String);

          String imagePath = userDetails['imageUrl'];
          String nameOfUser = userDetails['name'];

          setState(() {
            imageFile = File(imagePath);
            name = nameOfUser;
            _isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User details does not exists'),
          ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      margin: EdgeInsets.all(20),
                      child: Image.file(imageFile!)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Hi, $name', style: TextStyle(fontSize: 32)),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Text('Next'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SecondScreen()));
                    },
                  )
                ],
              ),
      ),
    );
  }
}
