import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: (){
        debugPrint("O Botão foi apertado");
      },
       child: Text("Estou na outra pagina")),
    );
  }
}
