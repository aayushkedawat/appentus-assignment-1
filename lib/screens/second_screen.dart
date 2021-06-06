import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool _isLoading = true;
  @override
  initState() {
    super.initState();

    Future.delayed(Duration.zero).then((_) {
      get(Uri.parse('https://picsum.photos/v2/list')).then((response) {
        if (response.statusCode == 200) {
          List imagesFromServer = jsonDecode(response.body);

          setState(() {
            imagesList = imagesFromServer;
            _isLoading = false;
          });
          // imagesList.add(value)
        }
      }).catchError((onError) {
        print(onError.toString());
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  List imagesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Second Screen'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(height: 20),
        MyWidget(),
        SizedBox(height: 20),
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: GridView.builder(
                    itemCount: imagesList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Expanded(
                                child: Image.network(
                                    imagesList[index]['download_url'])),
                            Text(imagesList[index]['author'])
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
      ]),
    );
  }
}

class MyWidget extends StatelessWidget {
  final personNextToMe =
      'That reminds me about the time when I was ten and our neighbour, her name was Mrs. Mable, and she said...';
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.airline_seat_legroom_reduced),
        Expanded(
          child: Text(
            personNextToMe,
          ),
        ),
        Icon(Icons.airline_seat_legroom_reduced),
      ],
    );
  }
}

class Recipe {
  int cows;
  int trampolines;
  Recipe(this.cows, this.trampolines);
  int get makeMilkSake => cows + trampolines;
}
