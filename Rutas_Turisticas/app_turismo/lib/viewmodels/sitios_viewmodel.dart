import 'package:flutter/material.dart';
import '../models/sitio_turistico.dart';
import '../services/sitios_service.dart';

class SitiosViewModel extends ChangeNotifier {
  final SitiosService _sitiosService = SitiosService();
  
  List<SitioTuristico> _sitios = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SitioTuristico> get sitios => _sitios;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SitiosViewModel() {
    inicializar();
  }

  Future<void> inicializar() async {
    await _sitiosService.inicializarDatos();
    await cargarSitios();
  }

  Future<void> cargarSitios() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sitios = await _sitiosService.getSitios();
    } catch (e) {
      _errorMessage = 'Error al cargar sitios: $e';
      print('Error cargando sitios: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearSitio({
    required String nombre,
    required String descripcion,
    required double latitud,
    required double longitud,
    String categoria = 'general',
    List<String> imagenes = const [],
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _sitiosService.crearSitio(
        nombre: nombre,
        descripcion: descripcion,
        latitud: latitud,
        longitud: longitud,
        categoria: categoria,
        imagenes: imagenes,
      );
      
      // Recargar sitios después de crear uno nuevo
      await cargarSitios();
    } catch (e) {
      _errorMessage = 'Error al crear sitio: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  SitioTuristico? getSitioById(String id) {
    try {
      return _sitios.firstWhere((sitio) => sitio.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
     