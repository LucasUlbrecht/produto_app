import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Certifique-se de que este arquivo está presente e importado
import 'login_page.dart';
import 'barcode_scanner_page.dart';
import 'register_page.dart'; // Importe a nova página
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use as opções geradas
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor de Código de Barras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Suporte para português do Brasil
      ],
      home: const LoginPage(),
      routes: {
        '/scanner': (context) => const BarcodeScannerPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) =>
            RegisterPage(), // Adicione a rota para a página de registro
      },
    );
  }
}
