import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../models/sitio_turistico.dart';
import '../comentarios/comentarios_view.dart';

class SitioDetalleView extends StatefulWidget {
  final SitioTuristico sitio;

  const SitioDetalleView({Key? key, required this.sitio}) : super(key: key);

  @override
  _SitioDetalleViewState createState() => _SitioDetalleViewState();
}

class _SitioDetalleViewState extends State<SitioDetalleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sitio.nombre),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              if (!authViewModel.isAuthenticated) {
                return SizedBox.shrink();
              }

              final isFavorito = authViewModel.isFavorito(widget.sitio.id);
              
              return IconButton(
                icon: Icon(
                  isFavorito ? Icons.favorite : Icons.favorite_border,
                  color: isFavorito ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  if (isFavorito) {
                    authViewModel.eliminarFavorito(widget.sitio.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Eliminado de favoritos')),
                    );
                  } else {
                    authViewModel.agregarFavorito(widget.sitio.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Agregado a favoritos')),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del sitio (placeholder)
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue[300]!,
                    Colors.blue[600]!,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.sitio.nombre,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y ubicación
                  Text(
                    widget.sitio.nombre,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${widget.sitio.latitud.toStringAsFixed(4)}, ${widget.sitio.longitud.toStringAsFixed(4)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Descripción
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.sitio.descripcion,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 24),

                  // Secciones de acción
                  _buildActionSection(
                    context,
                    'Ver en Mapa',
                    Icons.map,
                    Colors.green,
                    () => _verEnMapa(context),
                  ),
                  SizedBox(height: 12),
                  _buildActionSection(
                    context,
                    'Ver Comentarios',
                    Icons.comment,
                    Colors.blue,
                    () => _verComentarios(context),
                  ),
                  SizedBox(height: 12),
                  _buildActionSection(
                    context,
                    'Compartir',
                    Icons.share,
                    Colors.orange,
                    () => _compartir(context),
                  ),

                  SizedBox(height: 32),

                  // Información adicional
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información Adicional',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(Icons.access_time, 'Horario', 'Abierto 24 horas'),
                          _buildInfoRow(Icons.local_parking, 'Estacionamiento', 'Disponible'),
                          _buildInfoRow(Icons.wheelchair_pickup, 'Accesibilidad', 'Parcial'),
                          _buildInfoRow(Icons.pets, 'Mascotas', 'Permitidas'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(
    BuildContext context,
    String titulo,
    IconData icono,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icono, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                titulo,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.8),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icono, String titulo, String valor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Text(
            '$titulo: ',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }

  void _verEnMapa(BuildContext context) {
    // TODO: Implementar navegación al mapa con el sitio marcado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidad de mapa en desarrollo')),
    );
  }

  void _verComentarios(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComentariosView(
          sitioId: widget.sitio.id,
          sitioNombre: widget.sitio.nombre,
        ),
      ),
    );
  }

  void _compartir(BuildContext context) {
    // TODO: Implementar funcionalidad de compartir
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidad de compartir en desarrollo')),
    );
  }
}
