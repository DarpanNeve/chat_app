import 'package:chat_app/auth/registration_page.dart';
import 'package:flutter/material.dart';

import '../auth_service.dart';

var _pass = TextEditingController();
var _email = TextEditingController();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                child: SizedBox(
                  width: 344,
                  height: 550,
                  child: Column(
                    children: [
                      const Text(
                        "Welcome",
                        style: TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'LOGIN ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                      const PasswordButton(),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Forgot Password ?',
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          AuthService().signInWithEmailAndPassword(
                              _email.text, _pass.text, context);
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
                                "Login",
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
                      GestureDetector(
                        onTap: () {
                          AuthService().signInWithGoogle(context);
                        },
                        child: Container(
                          width: 202,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 40,
                                  height: 40,
                                  child:
                                      Image.asset('assets/Images/Google.png')),
                              const Text(
                                "Sign In With Google",
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
                        height: 10,
                      ),
                      const Text('OR'),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Don't Have An Account ? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()));
                        },
                        child: const Text(
                          "Register Now ",
                          style: TextStyle(color: Colors.lightBlue),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
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

class PasswordButton extends StatefulWidget {
  const PasswordButton({super.key});

  @override
  State<PasswordButton> createState() => _PasswordButtonState();
}

class _PasswordButtonState extends State<PasswordButton> {
  bool passEncrypted = true;
  bool obSecureText = true;

  @override
  void dispose() {
    _email.text = "";
    _pass.text = "";
    // TODO: implement dispose
    super.dispose();
  }

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
