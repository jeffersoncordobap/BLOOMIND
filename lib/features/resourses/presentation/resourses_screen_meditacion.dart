import 'package:flutter/material.dart';

class widget_meditacion extends StatelessWidget {
  const widget_meditacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Barra superior
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text("Meditación y respiración"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Text("En Desarrollo")

      );

      
  }
}