import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _fetchPalavra() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.5:3000/api/palavra'),
      );

      if (response.statusCode == 200) {
        debugPrint('Resposta: ${response.body}');
      } else {
        debugPrint('Erro: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro na requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Texto que ja tava aqui antes e eu n quero tirar"),
          ElevatedButton(
            onPressed: _fetchPalavra,
            child: Text("Aperta eu pra eu testar a API namoral"),
          ),
        ],
      ),
    );
  }
}
