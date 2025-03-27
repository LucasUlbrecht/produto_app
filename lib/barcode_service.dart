import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BarcodeService {
  final String serverUrl;

  BarcodeService(this.serverUrl);

  // Atualizar para retornar `http.Response`
  Future<http.Response?> sendBarcode(String barcode, String userId) async {
    try {
      final url = '$serverUrl/barcode';
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'barcode': barcode,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 404) {
        return response; // Retorna o objeto `http.Response`
      } else {
        if (kDebugMode) {
          print('Erro: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao enviar o código: $e');
      }
      return null;
    }
  }

  // Função para enviar o nome do produto para ser cadastrado no servidor
  Future<http.Response?> addProduct(
      String barcode, String productName, String userId) async {
    try {
      final url = '$serverUrl/add_product';
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'barcode': barcode,
        'product_name': productName,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return response; // Retorna o objeto `http.Response`
      } else {
        if (kDebugMode) {
          print('Erro ao cadastrar o produto: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao cadastrar o produto: $e');
      }
      return null;
    }
  }
}
