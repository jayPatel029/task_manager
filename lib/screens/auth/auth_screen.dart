import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth/auth_notifier.dart';
import '../../services/auth/auth_state.dart';
import '../common_widgets.dart';

class AuthScreen extends ConsumerStatefulWidget {
  AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController emailCont = TextEditingController(text: "jaypatel@gmail.com");
  final TextEditingController passCont = TextEditingController(text: "pass1234");
  bool showPass = false;

  void showTopSnackBar(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.red,
        // behavior: SnackBarBehavior.,
        // margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    if (authState is AuthFailure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTopSnackBar(context, "Error Logging in!");
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),

               Center(
                child: Icon(
                  Icons.login_rounded,
                  color: Colors.blue[600],
                  size: 100,
                ),
              ),
              const SizedBox(height: 10),

               const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 30),

                 Text(
                "Email",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: primDB,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: inputDece(),
                child: TextfieldHelper(
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                  controller: emailCont,
                ),
              ),
              const SizedBox(height: 20),

                 Text(
                "Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: primDB,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: inputDece(),
                child: TextField(
                  obscureText: !showPass,
                  controller: passCont,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPass ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),


              const SizedBox(height: 30),

               Center(
                child: ElevatedButton(
                  onPressed: () {
                    final email = emailCont.text.trim();
                    final password = passCont.text.trim();
                    ref.read(authNotifierProvider.notifier).login(email, password);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: authState is AuthLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Or continue with",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2), 
                            borderRadius: BorderRadius.circular(50), 
                          ),
                          child: IconButton(
                            onPressed: () {
                              showTopSnackBar(context, "Google login coming soon!", color: Colors.blue[600]);

                            },
                            icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                            iconSize: 40,
                            tooltip: "Google Login",
                          ),
                        ),
                        const SizedBox(width: 20),
                         Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),  
                            borderRadius: BorderRadius.circular(50),  
                          ),
                          child: IconButton(
                            onPressed: () {
                              showTopSnackBar(context, "Apple login coming soon!", color: Colors.blue[600]);

                            },
                            icon: const Icon(Icons.apple, color: Colors.black),
                            iconSize: 40,
                            tooltip: "Apple Login",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // if (authState is AuthFailure)
              //
              //   // const Padding(
              //   //   padding: EdgeInsets.only(top: 20.0),
              //   //   child: Center(
              //   //     child: Text(
              //   //       "Failed to login",
              //   //       style: TextStyle(color: Colors.red),
              //   //     ),
              //   //   ),
              //   // ),
              // if (authState is AuthSuccess)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 20.0),
              //     child: Center(
              //       child: Text(
              //         'Welcome, ${emailCont.text}',
              //         style: const TextStyle(color: Colors.green),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration inputDece() {
    return BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}
