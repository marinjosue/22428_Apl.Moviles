import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/perfil_viewmodel.dart';
import '../../models/usuario.dart';

class PerfilView extends StatelessWidget {
  // Usa tu lógica de autenticación, aquí es fijo por ejemplo:
  final String uid = 'testuser123';

  @override
  Widget build(BuildContext context) {
    final perfilVM = Provider.of<PerfilViewModel>(context);

    return FutureBuilder(
      future: perfilVM.cargarPerfil(uid),
      builder: (context, snapshot) {
        if (perfilVM.cargando || perfilVM.usuario == null) {
          return Center(child: CircularProgressIndicator());
        }
        final Usuario usuario = perfilVM.usuario!;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundImage: null,
                child: Icon(Icons.person, size: 64),
              ),
              SizedBox(height: 16),
              Text(usuario.nombre, style: TextStyle(fontSize: 22)),
              Text(usuario.email, style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text("Editar Perfil"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => _EditarPerfilDialog(usuario: usuario, uid: uid),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EditarPerfilDialog extends StatefulWidget {
  final Usuario usuario;
  final String uid;
  const _EditarPerfilDialog({required this.usuario, required this.uid});

  @override
  State<_EditarPerfilDialog> createState() => _EditarPerfilDialogState();
}

class _EditarPerfilDialogState extends State<_EditarPerfilDialog> {
  late TextEditingController _nombre;
  late TextEditingController _email;

  @override
  void initState() {
    _nombre = TextEditingController(text: widget.usuario.nombre);
    _email = TextEditingController(text: widget.usuario.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final perfilVM = Provider.of<PerfilViewModel>(context, listen: false);

    return AlertDialog(
      title: Text("Editar Perfil"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: _nombre, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text("Guardar"),
          onPressed: () async {
            await perfilVM.actualizarPerfil(widget.uid, _nombre.text, _email.text);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
