import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mal_clone/firebase_options.dart';
import 'package:mal_clone/pages/auth/auth_page.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Game List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 104, 239)),
          useMaterial3: true,
        ),
        home: const MyAuthPage(),
        );
  }
}
