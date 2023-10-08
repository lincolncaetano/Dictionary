import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/views/cadastro_screen.dart';
import 'package:dictionary/views/recupera_senha_screen.dart';
import 'package:dictionary/views/util/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _login() async {
    try {
      DialogUtils.showLoadingDialog(context);

      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );

      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(user.user?.uid).set({
        "id" : user.user?.uid,
      });

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home');

    } catch (e) {
      print('Erro de login: $e');
      Navigator.pop(context);

      if(e.toString().toUpperCase().contains("invalid_email".toUpperCase())){
        DialogUtils.errorSuccessSnackbar(context, "Email invalido");
      }

      if(e.toString().toUpperCase().contains("invalid_login_credentials".toUpperCase())){
        DialogUtils.errorSuccessSnackbar(context, "email ou senha invalido");
      }

      //DialogUtils.showSuccessSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navegue para a tela de cadastro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroScreen()),
                );
              },
              child: Text('Não tem uma conta? Cadastre-se'),
            ),
            TextButton(
              onPressed: () {
                // Navegue para a tela de recuperação de senha
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecuperaSenhaScreen()),
                );
              },
              child: Text('Esqueceu sua senha?'),
            ),
          ],
        ),
      ),
    );
  }
}
