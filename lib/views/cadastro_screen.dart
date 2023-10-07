import 'package:dictionary/views/util/dialog_utils.dart';
import 'package:dictionary/views/util/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _cadastrar() async {
    try {
      DialogUtils.showLoadingDialog(context);

      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );

      Navigator.pop(context);
      DialogUtils.showSuccessSnackbar(context, 'Usuário cadastrado com sucesso');
    } catch (e) {
      print('Erro de cadastro: $e');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
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
              onPressed: _cadastrar,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
