import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'dart:convert';
import 'barcode_service.dart';
import 'product_input_dialog.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor de Código de Barras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
          bodyLarge: TextStyle(
            fontSize: 18.0,
            color: Colors.black87,
          ),
          labelLarge: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
      home: const BarcodeScannerPage(),
    );
  }
}

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String barcode = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BarcodeService _barcodeService = BarcodeService(
      'https://6471-2804-14c-7582-4438-2803-eada-3074-a64d.ngrok-free.app');

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        setState(() {
          barcode = result.rawContent;
        });
        await processBarcode(barcode);
      }
    } catch (e) {
      setState(() {
        barcode = 'Falha ao ler o código: $e';
      });
    }
  }

  Future<void> processBarcode(String barcode) async {
    User? user = _auth.currentUser;
    if (user != null) {
      final response = await _barcodeService.sendBarcode(barcode, user.uid);

      if (response != null) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedResponse['status'] == 'success') {
          // Lógica para sucesso
        } else if (decodedResponse['status'] == 'not_found') {
          await requestProductName();
        } else {
          showSnackbar('Erro: ${decodedResponse['message']}');
        }
      } else {
        showSnackbar('Falha ao processar o código');
      }
    } else {
      showSnackbar('Usuário não autenticado');
    }
  }

  Future<void> requestProductName() async {
    String? productName = await ProductInputDialog.show(context);
    if (productName != null && productName.isNotEmpty) {
      User? user = _auth.currentUser;
      if (user != null) {
        http.Response? response =
            await _barcodeService.addProduct(barcode, productName, user.uid);
        if (response != null) {
          final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Produto Cadastrado'),
                content: Text(
                    'Produto cadastrado com sucesso: ${decodedResponse['message']}'),
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
        } else {
          showSnackbar('Falha ao cadastrar o produto');
        }
      }
    } else {
      showSnackbar('Nome do produto não pode ser vazio');
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leitor de Código de Barras',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.table_chart),
                        title: const Text('Minhas Tabelas'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/tabelas');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Meu Perfil'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/perfil');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Código lido: $barcode',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: scanBarcode,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Escanear Código de Barras'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
