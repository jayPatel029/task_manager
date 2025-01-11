import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager_bloc/bloc/auth_bloc.dart';
import 'package:task_manager_bloc/bloc/task_bloc.dart';
import 'package:task_manager_bloc/screens/auth/auth_screen.dart';
import 'package:task_manager_bloc/screens/home/home_screen.dart';
import 'package:task_manager_bloc/services/auth_service.dart';
import 'package:task_manager_bloc/services/task_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authRepository = AuthRepository(FirebaseAuth.instance);
  final authService = AuthService(authRepository);

  final taskRepo = TaskRepository();
  final taskService = TaskService(taskRepo);

  runApp(MyApp(authService, taskService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final TaskService taskService;

  const MyApp(this.authService, this.taskService, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthBloc(authService),
            ),
            BlocProvider(
              create: (_) {
                print("taskblocinit");
                return TaskBloc(taskService);
              },
            ),
          ],
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              print('AuthBloc state: $state');

              if (state is AuthSuccess) {
                return HomeScreen();
              } else if (state is AuthFailure) {
                return AuthScreen();
              } else {
                return AuthScreen();
              }
            },
          ),
        ),
        // AuthScreen(),
      ),
    );
  }
}
