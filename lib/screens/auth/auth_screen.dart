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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                    ref
                        .read(authNotifierProvider.notifier)
                        .login(email, password);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primDB.withOpacity(0.8),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, color: Colors.white),
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
              if (authState is AuthFailure)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Failed to login",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              if (authState is AuthSuccess)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Welcome, ${emailCont.text}',
                      style: const TextStyle(color: Colors.green),
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
