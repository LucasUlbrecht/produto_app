# produto_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)


Rota	Método	Porta Interna	Porta Externa Recomendada	Descrição
/users	GET	5000	443 (HTTPS)	Lista todos os usuários
/barcode	POST	5000	443 (HTTPS)	Consulta produto por código de barras
/add_product	POST	5000	443 (HTTPS)	Adiciona novo produto
/products/<user_id>	GET	5000	443 (HTTPS)	Lista produtos de um usuário específico
