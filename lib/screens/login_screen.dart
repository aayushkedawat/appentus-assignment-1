import 'dart:convert';

import 'package:assignment_1/screens/home_screen.dart';
import 'package:assignment_1/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _emailNode = FocusNode();
  var _passwordNode = FocusNode();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  bool _isLoading = false;
  void _loginUser(String enteredEmail, String enteredPassword) {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('userDetails')) {
        Map<String, dynamic> userDetails =
            jsonDecode(prefs.getString('userDetails') as String);

        String email = userDetails['email'];
        String password = userDetails['password'];

        if (enteredEmail == email && enteredPassword == password) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User Logined Successfully'),
          ));

          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => new HomeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invalid credentials'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User details does not exists'),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("Login",
                  style: TextStyle(fontSize: 32), textAlign: TextAlign.left),
              SizedBox(
                height: 22,
              ),
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
                        _loginUser(
                            _emailController.text, _passwordController.text);
                      },
                      child: Container(
                          width: double.infinity,
                          height: 55,
                          child: Text("Login",
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
                            builder: (context) => new SignupScreen()));
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
