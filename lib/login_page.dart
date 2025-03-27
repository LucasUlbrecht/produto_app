import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState(); 
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Verifique se o widget ainda está montado antes de usar o BuildContext
      if (mounted && userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/scanner');
      }
    } catch (e) {
      // Verifique se o widget ainda está montado antes de mostrar o diálogo de erro
      if (mounted) {
        _showErrorDialog('Erro ao fazer login: $e');
      }
    }
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Verifique se o widget ainda está montado antes de usar o BuildContext
      if (mounted && userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/scanner');
      }
    } catch (e) {
      // Verifique se o widget ainda está montado antes de mostrar o diálogo de erro
      if (mounted) {
        _showErrorDialog('Erro ao registrar: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {  // Verifique se o widget ainda está montado
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/register'); // Navega para a página de registro
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
