import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/perfil_viewmodel.dart';

class PerfilView extends StatelessWidget {
  // Usa tu lógica de autenticación, aquí es fijo por ejemplo:
  final String uid = 'testuser123';

  @override
  Widget build(BuildContext context) {
    final perfilVM = Provider.of<PerfilViewModel>(context);

    return FutureBuilder(
      future: perfilVM.cargarPerfil(uid),
      builder: (context, snapshot) {
        if (perfilVM.cargando || perfilVM.perfil == null) {
          return Center(child: CircularProgressIndicator());
        }
        final perfil = perfilVM.perfil!;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundImage: perfil['photoUrl']?.isNotEmpty == true
                    ? NetworkImage(perfil['photoUrl'])
                    : null,
                child: perfil['photoUrl']?.isEmpty == true
                    ? Icon(Icons.person, size: 64)
                    : null,
              ),
              SizedBox(height: 16),
              Text(perfil['name'] ?? 'Viajero', style: TextStyle(fontSize: 22)),
              Text(perfil['email'] ?? '', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text("Editar Perfil"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => _EditarPerfilDialog(perfil: perfil, uid: uid),
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
  final Map<String, dynamic> perfil;
  final String uid;
  const _EditarPerfilDialog({required this.perfil, required this.uid});

  @override
  State<_EditarPerfilDialog> createState() => _EditarPerfilDialogState();
}

class _EditarPerfilDialogState extends State<_EditarPerfilDialog> {
  late TextEditingController _nombre;
  late TextEditingController _email;
  late TextEditingController _foto;

  @override
  void initState() {
    _nombre = TextEditingController(text: widget.perfil['name']);
    _email = TextEditingController(text: widget.perfil['email']);
    _foto = TextEditingController(text: widget.perfil['photoUrl']);
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
            TextField(controller: _foto, decoration: InputDecoration(labelText: 'Foto (URL)')),
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
            await perfilVM.actualizarPerfil(widget.uid, _nombre.text, _email.text, _foto.text);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
