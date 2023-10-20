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
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Welcome",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 30),
            const Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1F41BB),
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                decoration: const InputDecoration(
                    focusColor: Colors.white,
                    hintText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      size: 23,
                    ),
                    hintStyle: TextStyle(fontWeight: FontWeight.w400),
                    border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: TextFormField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(
                    focusColor: Colors.white,
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.password,
                      size: 23,
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/Images/Google.png',
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      "Sign In With Google",
                      style: TextStyle(
                          fontSize: 12,
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
        )),
      ),
    );
  }
}
