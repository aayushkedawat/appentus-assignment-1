import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/sign-up';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var _nameNode = FocusNode();
  var _emailNode = FocusNode();
  var _passwordNode = FocusNode();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _nameController = TextEditingController();

  bool _isLoading = false;
  File? _image;
  final picker = ImagePicker();
  Future<void> _takePicture() async {
    final imageFile =
        await picker.getImage(source: ImageSource.gallery, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    File _storedImage = File.fromUri(Uri.parse(imageFile.path));
    setState(() {
      _storedImage = File.fromUri(Uri.parse(imageFile.path));
    });
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    setState(() {
      _image = savedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _image != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            height: 70,
                            child: Image.file(_image!)),
                        TextButton(onPressed: _takePicture, child: Text('Edit'))
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        child: Text('Select Image'),
                        onPressed: _takePicture,
                      ),
                    ),
              SizedBox(
                height: 5,
              ),
              Text("Signup to join us",
                  style: TextStyle(fontSize: 32), textAlign: TextAlign.left),
              SizedBox(
                height: 22,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 60,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    focusNode: _nameNode,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      _emailNode.requestFocus();
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Your given name',
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(
                            color: const Color(0xffb6c5d1),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelStyle: const TextStyle(
                          color: const Color(0xff0d3f67),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: const Color(0xfff0f3f6))),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 60,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    focusNode: _emailNode,
                    onSubmitted: (value) {
                      _passwordNode.requestFocus();
                    },
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'E.g: yourname@email.com',
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(
                            color: const Color(0xffb6c5d1),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelStyle: const TextStyle(
                          color: const Color(0xff0d3f67),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: const Color(0xfff0f3f6))),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 60,
                  child: TextField(
                    obscureText: true,
                    focusNode: _passwordNode,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(
                            color: const Color(0xffb6c5d1),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14),
                        labelStyle: const TextStyle(
                          color: const Color(0xff0d3f67),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: const Color(0xfff0f3f6))),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : InkWell(
                      onTap: () {
                        if (_nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please enter name'),
                          ));
                          return;
                        }
                        if (_image == null || _image!.path.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please select image'),
                          ));
                          return;
                        }
                        if (_emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please enter email'),
                          ));
                          return;
                        }
                        if (_passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please enter password'),
                          ));
                          return;
                        }
                        SharedPreferences.getInstance().then((prefs) {
                          Map<String, dynamic> users = {
                            'name': _nameController.text,
                            'email': _emailController.text,
                            'password': _passwordController.text,
                            'imageUrl': _image!.path
                          };
                          prefs
                              .setString('userDetails', jsonEncode(users))
                              .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text('User details saved successfully'),
                                  )));
                        });
                      },
                      child: Container(
                          width: double.infinity,
                          height: 55,
                          child: Text("Sign Up",
                              style: TextStyle(
                                  color: Color(0xffffffff), fontSize: 20),
                              textAlign: TextAlign.center),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              color: Theme.of(context).primaryColor)),
                    ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new LoginScreen()));
                  },
                  child: Text("Already registered ? Login",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
