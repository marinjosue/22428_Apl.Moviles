import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/propietario_viewmodel.dart';
import 'detalle_propietario_view.dart';

class UsuarioView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PropietarioViewModel()..cargarPropietarios(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],

        body: Consumer<PropietarioViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600]!),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando propietarios...',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else if (viewModel.error != null) {
              return Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[600],
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Error',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${viewModel.error}',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else if (viewModel.propietarios.isEmpty) {
              return Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: Colors.green[300],
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay propietarios',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Aún no se han registrado propietarios en el sistema',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListView.builder(
                      itemCount: viewModel.propietarios.length,
                      itemBuilder: (context, index) {
                        final p = viewModel.propietarios[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.green[100]!,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.green[700],
                                size: 28,
                              ),
                            ),
                            title: Text(
                              p.nombreCompleto,
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.cake_outlined,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Edad: ${p.edad}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.directions_car_outlined,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Automóviles: ${p.automovilIds.join(", ")}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            trailing: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.green[600],
                                size: 18,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetallePropietarioView(propietario: p),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),


      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00C851),
            Color(0xFF00BF63),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C851).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.people_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lista de Propietarios',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Gestiona la información de todos los propietarios',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}