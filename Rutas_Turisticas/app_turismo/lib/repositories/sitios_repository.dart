import 'package:flutter/services.dart';
import '../models/sitio_turistico.dart';
import '../services/firestore_service.dart';

class SitiosRepository {
  final FirestoreService _firestoreService = FirestoreService();

  // Simulado, luego conecta Firestore
  List<SitioTuristico> obtenerSitios() {
    return [
      SitioTuristico(
        id: '1',
        nombre: 'Mitad del Mundo',
        descripcion: 'Monumento icónico de Ecuador',
        latitud: -0.002789,
        longitud: -78.455833,
      ),
      SitioTuristico(
        id: '2',
        nombre: 'Centro Histórico',
        descripcion: 'Patrimonio cultural de la humanidad',
        latitud: -0.2201641,
        longitud: -78.5123274,
      ),
    ];
  }

  Future<List<SitioTuristico>> obtenerSitiosFromFirestore() async {
    try {
      final sitios = await _firestoreService.getSitios();
      if (sitios.isNotEmpty) {
        return sitios;
      }
      // Fallback to local data
      return obtenerSitios();
    } on PlatformException catch (e) {
      print('PlatformException in obtenerSitiosFromFirestore: ${e.code}');
      // Return local fallback data
      return obtenerSitios();
    } catch (e) {
      print('Error in obtenerSitiosFromFirestore: $e');
      return obtenerSitios();
    }
  }
}
