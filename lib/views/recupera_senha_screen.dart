import 'package:dictionary/views/util/dialog_utils.dart';
import 'package:dictionary/views/util/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RecuperaSenhaScreen extends StatefulWidget {
  @override
  _RecuperaSenhaScreenState createState() => _RecuperaSenhaScreenState();
}

class _RecuperaSenhaScreenState extends State<RecuperaSenhaScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _recuperarSenha() async {
    try {
      DialogUtils.showLoadingDialog(context);

      await _auth.sendPasswordResetEmail(email: _emailController.text);

      Navigator.pop(context);
      DialogUtils.showSuccessSnackbar(context, 'Email enviado com sucesso');

    } catch (e) {
      print('Erro ao recuperar senha: $e');
      Navigator.pop(context);

      if(e.toString().contains("[firebase_auth/missing-email]")){
        DialogUtils.errorSuccessSnackbar(context, "Campo email é obrigatório");
      }
      if(e.toString().contains("[firebase_auth/invalid-email]")){
        DialogUtils.errorSuccessSnackbar(context, "Email inválido");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
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
            ElevatedButton(
              onPressed: _recuperarSenha,
              child: Text('Recuperar Senha'),
            ),
          ],
        ),
      ),
    );
  }
}
