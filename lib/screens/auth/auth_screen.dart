import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_bloc/services/auth/auth_notifier.dart';

import '../../services/auth/auth_state.dart';
import '../common_widgets.dart';

class AuthScreen extends ConsumerWidget {
  AuthScreen({super.key});

  TextEditingController emailCont =
      TextEditingController(text: "jaypatel@gmail.com");

  TextEditingController passCont = TextEditingController(text: "pass1234");
  void showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
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
                    fontSize: 30,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Email Text and Field
              Text(
                "Email",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555)),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextfieldHelper(
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                  controller: emailCont,
                ),
              ),
              SizedBox(height: 20),

              // Password Text and Field
              Text(
                "Password",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555)),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextfieldHelper(
                  obscureText: true,
                  hintText: 'Enter your password',
                  controller: passCont,
                ),
              ),
              SizedBox(height: 30),

              // Login Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final email = emailCont.text.trim();
                    final password = passCont.text.trim();
                    ref
                        .read(authNotifierProvider.notifier)
                        .login(email, password);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF676bF3),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: authState is AuthLoading
                      ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // Error/Success Messages
              if (authState is AuthFailure)
                ScaffoldMessenger(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Failed to login",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              if (authState is AuthSuccess)
                ScaffoldMessenger(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Welcome, ${emailCont.text}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
