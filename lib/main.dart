import 'package:flutter/material.dart';
import 'package:flutter_task/features/login/screens/login_screen.dart';
import 'package:flutter_task/features/home/home_screen.dart';
import 'package:flutter_task/features/shared_pref/token.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  String? token = null;
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  checkToken() async {
    setState(() {
      isLoading = true;
    });
    token = await SharedPrefToken().getToken();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: false,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          )),
      home: isLoading
          ? Material(
              child: Center(child: CircularProgressIndicator()),
            )
          : token == null
              ? LoginScreen()
              : HomeScreen(),
    );
  }
}

//eve.holt@reqres.in
// echo "# flutter_task" >> README.md
// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/avipanthi007/flutter_task.git
// git push -u origin main