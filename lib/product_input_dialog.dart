import 'package:flutter/material.dart';

class ProductInputDialog {
  static Future<String?> show(BuildContext context) async {
    String? productName;

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nome do Produto'),
          content: TextField(
            onChanged: (value) {
              productName = value;
            },
            decoration: const InputDecoration(hintText: "Digite o nome do produto"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(productName);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    return productName; // Retorna o nome do produto digitado
  }
}
