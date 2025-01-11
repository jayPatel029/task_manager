import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_bloc/bloc/auth_bloc.dart';

import '../common_widgets.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  TextEditingController emailCont = TextEditingController(text: "jaypatel@gmail.com");

  TextEditingController passCont = TextEditingController(text: "pass1234");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Login Successful: ${state.user.email}')),
              );
              // Navigate to another screen
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          }, builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                ),
                Center(
                  child: Icon(
                    Icons.login_rounded,
                    color: Color(0xFF676bF3),
                    size: 100,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Email",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: primDB),
                ),
                SizedBox(height: 8),
                TextfieldHelper(
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                  controller: emailCont,
                ),
                SizedBox(height: 20),
                Text(
                  "Password",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: primDB),
                ),
                SizedBox(height: 8),
                TextfieldHelper(
                  obscureText: true,
                  hintText: 'Enter your password',
                  controller: passCont,
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print('Email: ${emailCont.text}');
                      print('Password: ${passCont.text}');
                      final email = emailCont.text.trim();
                      final password = passCont.text.trim();
                      BlocProvider.of<AuthBloc>(context).add(
                        LoginEvent(email, password),
                      );
                    },
                    child: state is AuthLoading
                        ? CircularProgressIndicator(
                            color: primDB,
                          )
                        : Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primDB.withOpacity(0.8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
