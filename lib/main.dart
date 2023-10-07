import 'package:dictionary/firebase_options.dart';
import 'package:dictionary/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  auth = FirebaseAuth.instanceFor(app: app);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary',
      initialRoute: _checkInitialRoute(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: AppRoutes.routes,
    );
  }

  String _checkInitialRoute() {
    User? user = _auth.currentUser;
    if (user != null) {
      return '/home'; // Usuário logado, redirecionar para a página inicial
    } else {
      return '/'; // Nenhum usuário logado, redirecionar para a página de login
    }
  }
}

