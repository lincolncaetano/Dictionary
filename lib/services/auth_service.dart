import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AuthService {
  Future<String?> obterIdUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      return null; // Não há usuário logado
    }
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    DefaultCacheManager().emptyCache();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
