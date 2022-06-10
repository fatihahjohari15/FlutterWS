import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/views/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mytutor/views/registerscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  bool remember = false;
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // ignore: prefer_const_constructors
        backgroundColor: Color.fromARGB(255, 211, 168, 197),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: ctrwidth,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height: screenHeight / 2.5,
                              width: screenWidth,
                              child:
                                  Image.asset('assets/images/MYTutorLogo.png')),
                          const Text(
                            "Login",
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emailCtrl,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid email';
                              }
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);

                              if (!emailValid) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: passwordCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: remember,
                                onChanged: (bool? value) {
                                  _onRememberMeChanged(value!);
                                },
                              ),
                              const Text("Remember Me")
                            ],
                          ),
                          SizedBox(
                            width: screenWidth,
                            height: 50,
                            child: ElevatedButton(
                              child: const Text("Login"),
                              onPressed: _loginUser,
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text("Not register yet? ",
                                    style: TextStyle(fontSize: 15.0)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const RegisterScreen()));
                                  },
                                  child: const Text(
                                    "Register Here",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String email = emailCtrl.text;
      String password = passwordCtrl.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('remember', true);
        Fluttertoast.showToast(
            msg: "Preference Stored",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        await prefs.setString('email', '');
        await prefs.setString('pass', '');
        await prefs.setBool('remember', false);
        emailCtrl.text = "";
        passwordCtrl.text = "";
        Fluttertoast.showToast(
            msg: "Preference Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Preference Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      remember = false;
    }
  }

  void _onRememberMeChanged(bool value) {
    remember = value;
    setState(() {
      if (remember) {
        _saveRemovePref(true);
      } else {
        _saveRemovePref(false);
      }
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        emailCtrl.text = email;
        passwordCtrl.text = password;
        remember = true;
      });
    }
  }

  void _loginUser() {
    String _email = emailCtrl.text;
    String _password = passwordCtrl.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      http.post(
          Uri.parse("http://10.31.154.113/mytutor/mobile/php/login_user.php"),
          body: {"email": _email, "password": _password}).then((response) {
        // ignore: avoid_print
        print(response.body);
        if (response.body == "success") {
          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => const MainScreen()));
        } else {
          Fluttertoast.showToast(
              msg: "Login Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      });
    }
  }
}
