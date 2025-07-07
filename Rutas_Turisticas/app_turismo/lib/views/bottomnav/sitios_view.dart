import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/api_config.dart';

class SitiosView extends StatefulWidget {
  const SitiosView({super.key});

  @override
  State<SitiosView> createState() => _SitiosViewState();
}

class _SitiosViewState extends State<SitiosView> {
  List<dynamic> sitios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarSitios();
  }

  Future<void> cargarSitios() async {
    final url = Uri.parse('${ApiConfig.apiBase}/sitios');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        sitios = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      // Aquí puedes manejar errores si quieres
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (sitios.isEmpty) {
      return const Center(child: Text('No hay sitios disponibles.'));
    }

    return ListView.builder(
      itemCount: sitios.length,
      itemBuilder: (context, index) {
        final sitio = sitios[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.place),
            title: Text(sitio['nombre']),
            subtitle: Text(sitio['descripcion']),
            onTap: () {
              // Aquí puedes navegar a detalle si deseas
            },
          ),
        );
      },
    );
  }
}
