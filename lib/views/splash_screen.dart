import 'package:dictionary/services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _carregaUsuario();
  }

  void _carregaUsuario() async{

    await Future.delayed(const Duration(seconds: 4));

    await AuthService().obterIdUsuarioLogado()!= null
        ? Navigator.pushReplacementNamed(context, '/home')
        : Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Dictionary"),
      ),
    );
  }
}
