

import 'package:dictionary/views/cadastro_screen.dart';
import 'package:dictionary/views/home_screen.dart';
import 'package:dictionary/views/login_screen.dart';
import 'package:dictionary/views/recupera_senha_screen.dart';
import 'package:dictionary/views/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => SplashScreen(),
    '/login': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
    '/cadastro': (context) => CadastroScreen(),
    '/recuperaSenha': (context) => RecuperaSenhaScreen()
  };
}
