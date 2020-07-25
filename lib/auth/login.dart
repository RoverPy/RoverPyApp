import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_in/auth/constants.dart';
import 'package:sign_in/services/AuthService.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView, controller;
  LoginScreen({this.toggleView, this.controller});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      height: 400,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "RoverPy",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .6,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      prefixIcon: Icon(Icons.email), hintText: "Email ID"),
                  validator: (val) {
                    return val.isEmpty ? "Enter a valid email" : null;
                  },
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                      prefixIcon: Icon(Icons.lock), hintText: "Password"),
                  validator: (val) {
                    return val.length < 6
                        ? "Oops! Password seems too short"
                        : null;
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: InkWell(
                        child: FlatButton(
                          padding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          onPressed: () async {
                            //async action here
                            if (_formKey.currentState.validate()) {
                              dynamic res = await _auth.signInWithEmailAndPass(
                                  email, password);
                              print(res);
                              if (res == null) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Something went wrong! Make sure your credentials are correct and retry!"),
                                ));
                              } else {
                                widget.controller();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Successfully logged in!"),
                                ));
                              }
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.teal, Colors.teal[200]],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24.0)),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 30.0),
                              child: Text(
                                "SIGN IN",
                                style: TextStyle(
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        widget.toggleView();
                      },
                      child: Text(
                        'Register?',
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
