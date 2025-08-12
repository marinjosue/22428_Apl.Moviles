import 'package:flutter/material.dart';
import '../utils/constants.dart';

class InformacionVialScreen extends StatelessWidget {
  const InformacionVialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Señales Viales'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Señales de Tránsito',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Conoce las principales señales de tránsito y su significado:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            
            // Señales de Prohibición
            _buildSeccionSenales(
              'Señales de Prohibición',
              [
                _SignalInfo(
                  'Prohibido el Paso',
                  'Indica que está prohibido el paso de vehículos',
                  'assets/images/prohibido_paso.jpg',
                  Colors.red,
                ),
                _SignalInfo(
                  'Prohibido Estacionar',
                  'No se permite estacionar vehículos en esta zona',
                  'assets/images/prohibido_estacionar.jpg',
                  Colors.red,
                ),
                _SignalInfo(
                  'Prohibido Girar a la Izquierda',
                  'No está permitido realizar giros hacia la izquierda',
                  'assets/images/prohibido_izquierda.jpg',
                  Colors.red,
                ),
                _SignalInfo(
                  'Prohibido Adelantar',
                  'No se permite adelantar a otros vehículos',
                  'assets/images/prohibido_adelantar.png',
                  Colors.red,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Señales de Obligación
            _buildSeccionSenales(
              'Señales de Obligación',
              [
                _SignalInfo(
                  'Dirección Obligatoria',
                  'Indica la dirección que deben seguir los vehículos',
                  'assets/images/direccion_obligatoria.jpg',
                  Colors.blue,
                ),
                _SignalInfo(
                  'Uso Obligatorio de Cinturón',
                  'Es obligatorio usar cinturón de seguridad',
                  'assets/images/cinturon_obligatorio.png',
                  Colors.blue,
                ),
                _SignalInfo(
                  'Velocidad Mínima',
                  'Indica la velocidad mínima permitida',
                  'assets/images/velocidad_minima.png',
                  Colors.blue,
                ),
                _SignalInfo(
                  'Solo Peatones',
                  'Vía exclusiva para el tránsito de peatones',
                  'assets/images/solo_peatones.jpg',
                  Colors.blue,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Señales de Advertencia
            _buildSeccionSenales(
              'Señales de Advertencia',
              [
                _SignalInfo(
                  'Curva Peligrosa',
                  'Advierte sobre la presencia de una curva peligrosa',
                  'assets/images/curva_peligrosa.jpg',
                  Colors.orange,
                ),
                _SignalInfo(
                  'Zona Escolar',
                  'Indica proximidad a una zona escolar',
                  'assets/images/zona_escolar.png',
                  Colors.orange,
                ),
                _SignalInfo(
                  'Cruce de Peatones',
                  'Advierte sobre un cruce peatonal próximo',
                  'assets/images/cruce_peatones.jpg',
                  Colors.orange,
                ),
                _SignalInfo(
                  'Superficie Resbaladiza',
                  'Precaución por superficie resbaladiza',
                  'assets/images/resbaladizo.jpg',
                  Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Señales Informativas
            _buildSeccionSenales(
              'Señales Informativas',
              [
                _SignalInfo(
                  'Hospital',
                  'Indica la ubicación de un centro de salud',
                  'assets/images/hospital.jpg',
                  Colors.green,
                ),
                _SignalInfo(
                  'Gasolinera',
                  'Señala la ubicación de una estación de servicio',
                  'assets/images/gasolinera.png',
                  Colors.green,
                ),
                _SignalInfo(
                  'Estacionamiento',
                  'Indica zona de estacionamiento disponible',
                  'assets/images/estacionamiento.jpg',
                  Colors.green,
                ),
                _SignalInfo(
                  'Información Turística',
                  'Punto de información para turistas',
                  'assets/images/info_turistica.jpg',
                  Colors.green,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionSenales(String titulo, List<_SignalInfo> senales) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: senales.length,
          itemBuilder: (context, index) {
            final senal = senales[index];
            return _buildTarjetaSenal(senal);
          },
        ),
      ],
    );
  }

  Widget _buildTarjetaSenal(_SignalInfo senal) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              senal.color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: senal.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.asset(
                senal.imagenPath,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              senal.nombre,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: senal.color,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              senal.descripcion,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalInfo {
  final String nombre;
  final String descripcion;
  final String imagenPath;
  final Color color;

  _SignalInfo(this.nombre, this.descripcion, this.imagenPath, this.color);
}