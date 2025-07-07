import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/comentario_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../models/comentario.dart';

class ComentariosView extends StatefulWidget {
  final String sitioId;
  final String sitioNombre;

  const ComentariosView({
    Key? key,
    required this.sitioId,
    required this.sitioNombre,
  }) : super(key: key);

  @override
  _ComentariosViewState createState() => _ComentariosViewState();
}

class _ComentariosViewState extends State<ComentariosView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ComentarioViewModel>(context, listen: false)
          .cargarComentariosBySitio(widget.sitioId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios - ${widget.sitioNombre}'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Consumer2<ComentarioViewModel, AuthViewModel>(
        builder: (context, comentarioViewModel, authViewModel, child) {
          if (comentarioViewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Calificación promedio
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 30),
                    SizedBox(width: 8),
                    Text(
                      comentarioViewModel.calificacionPromedio.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '(${comentarioViewModel.comentarios.length} comentarios)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              // Lista de comentarios
              Expanded(
                child: comentarioViewModel.comentarios.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay comentarios aún',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '¡Sé el primero en comentar!',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: comentarioViewModel.comentarios.length,
                        itemBuilder: (context, index) {
                          final comentario = comentarioViewModel.comentarios[index];
                          return _buildComentarioCard(comentario, authViewModel);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          if (!authViewModel.isAuthenticated) {
            return SizedBox.shrink();
          }
          
          return FloatingActionButton(
            onPressed: () => _mostrarDialogoComentario(context),
            child: Icon(Icons.add_comment),
            backgroundColor: Colors.blue[700],
          );
        },
      ),
    );
  }

  Widget _buildComentarioCard(Comentario comentario, AuthViewModel authViewModel) {
    final esAutorComentario = authViewModel.userData?.id == comentario.usuarioId;
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre y calificación
            Row(
              children: [
                CircleAvatar(
                  child: Text(comentario.nombreUsuario.isNotEmpty 
                      ? comentario.nombreUsuario[0].toUpperCase() 
                      : 'U'),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comentario.nombreUsuario,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < comentario.calificacion 
                                  ? Icons.star 
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                          SizedBox(width: 8),
                          Text(
                            comentario.fecha.day.toString().padLeft(2, '0') +
                                '/' + comentario.fecha.month.toString().padLeft(2, '0') +
                                '/' + comentario.fecha.year.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (esAutorComentario)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'editar') {
                        _mostrarDialogoEditarComentario(context, comentario);
                      } else if (value == 'eliminar') {
                        _eliminarComentario(context, comentario.id);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'editar',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'eliminar',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Eliminar', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 12),
            
            // Texto del comentario
            Text(comentario.texto),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoComentario(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (!authViewModel.isAuthenticated || authViewModel.userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debes iniciar sesión para comentar')),
      );
      return;
    }

    _mostrarDialogoComentarioForm(
      context: context,
      titulo: 'Agregar Comentario',
      textoInicial: '',
      calificacionInicial: 5.0,
      onGuardar: (texto, calificacion) {
        final comentarioViewModel = Provider.of<ComentarioViewModel>(context, listen: false);
        comentarioViewModel.crearComentario(
          sitioId: widget.sitioId,
          usuarioId: authViewModel.userData!.id,
          nombreUsuario: authViewModel.userData!.nombre,
          texto: texto,
          calificacion: calificacion,
        );
      },
    );
  }

  void _mostrarDialogoEditarComentario(BuildContext context, Comentario comentario) {
    _mostrarDialogoComentarioForm(
      context: context,
      titulo: 'Editar Comentario',
      textoInicial: comentario.texto,
      calificacionInicial: comentario.calificacion,
      onGuardar: (texto, calificacion) {
        final comentarioViewModel = Provider.of<ComentarioViewModel>(context, listen: false);
        comentarioViewModel.actualizarComentario(
          comentarioId: comentario.id,
          sitioId: widget.sitioId,
          texto: texto,
          calificacion: calificacion,
        );
      },
    );
  }

  void _mostrarDialogoComentarioForm({
    required BuildContext context,
    required String titulo,
    required String textoInicial,
    required double calificacionInicial,
    required Function(String, double) onGuardar,
  }) {
    final textoController = TextEditingController(text: textoInicial);
    double calificacion = calificacionInicial;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(titulo),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Calificación
                  Text('Calificación:'),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < calificacion ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            calificacion = (index + 1).toDouble();
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 16),
                  
                  // Texto del comentario
                  TextField(
                    controller: textoController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Tu comentario',
                      border: OutlineInputBorder(),
                      hintText: 'Comparte tu experiencia...',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (textoController.text.trim().isNotEmpty) {
                      onGuardar(textoController.text.trim(), calificacion);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _eliminarComentario(BuildContext context, String comentarioId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar comentario'),
          content: Text('¿Estás seguro de que quieres eliminar este comentario?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final comentarioViewModel = Provider.of<ComentarioViewModel>(context, listen: false);
                comentarioViewModel.eliminarComentario(
                  comentarioId: comentarioId,
                  sitioId: widget.sitioId,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
