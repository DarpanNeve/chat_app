import 'package:flutter/material.dart';

import '../auth_service.dart';
import 'login_page.dart';

var _confirmPass = TextEditingController();
var _pass = TextEditingController();
var _email = TextEditingController();
var _name = TextEditingController();

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  bool passEncrypted = true;

  //Color customColor = Color(0x00d9d9d9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              const SizedBox(
                height: 25,
              ),
              Card(
                elevation: 20,
                child: Container(
                  width: 344,
                  height: 600,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      //   color: const Color(0xFFD9D9D9),
                      border: Border.all(color: Colors.black38)),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'REGISTRATION ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller: _email,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller: _name,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const PasswordButton1(),
                      const PasswordButton2(),
                      const SizedBox(
                        height: 4,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('OR', style: TextStyle())],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_pass.text == _confirmPass.text &&
                              _name.text.isNotEmpty &&
                              _email.text.isNotEmpty) {
                            await AuthService().createUserWithEmailAndPassword(
                                _name.text, _email.text, _pass.text, context);
                            if (context.mounted) Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('password do not match'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 202,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 16,
                                    // Set the text size
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text("Already Have An Account ? "),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text(
                            " Login ",
                            style: TextStyle(color: Colors.lightBlue),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordButton1 extends StatefulWidget {
  const PasswordButton1({super.key});

  @override
  State<PasswordButton1> createState() => _PasswordButton1State();
}

class _PasswordButton1State extends State<PasswordButton1> {
  bool obSecureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _pass,
        obscureText: obSecureText,
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: GestureDetector(
              onTap: () {
                setState(
                  () {
                    obSecureText = !obSecureText;
                  },
                );
              },
              child: obSecureText
                  ? const Icon(Icons.visibility_off, color: Colors.grey)
                  : const Icon(Icons.visibility, color: Colors.grey)),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

class PasswordButton2 extends StatefulWidget {
  const PasswordButton2({super.key});

  @override
  State<PasswordButton2> createState() => _PasswordButton2State();
}

class _PasswordButton2State extends State<PasswordButton2> {
  bool obSecureText = true;

  @override
  void dispose() {
    _name.text = "";
    _email.text = "";
    _pass.text = "";
    _confirmPass.text = "";
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _confirmPass,
        obscureText: obSecureText,
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: GestureDetector(
              onTap: () {
                setState(
                  () {
                    obSecureText = !obSecureText;
                  },
                );
              },
              child: obSecureText
                  ? const Icon(Icons.visibility_off, color: Colors.grey)
                  : const Icon(Icons.visibility, color: Colors.grey)),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
