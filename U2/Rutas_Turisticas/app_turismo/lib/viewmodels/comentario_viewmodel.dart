import 'package:flutter/material.dart';
import '../models/comentario.dart';
import '../services/comentario_service.dart';

class ComentarioViewModel extends ChangeNotifier {
  final ComentarioService _comentarioService = ComentarioService();
  
  List<Comentario> _comentarios = [];
  bool _isLoading = false;
  String? _errorMessage;
  double _calificacionPromedio = 0.0;

  List<Comentario> get comentarios => _comentarios;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get calificacionPromedio => _calificacionPromedio;

  Future<void> cargarComentariosBySitio(String sitioId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _comentarios = await _comentarioService.getComentariosBySitio(sitioId);
      _calificacionPromedio = await _comentarioService.getCalificacionPromedio(sitioId);
    } catch (e) {
      _errorMessage = 'Error al cargar comentarios: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearComentario({
    required String sitioId,
    required String usuarioId,
    required String nombreUsuario,
    required String texto,
    required double calificacion,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _comentarioService.crearComentario(
        sitioId: sitioId,
        usuarioId: usuarioId,
        nombreUsuario: nombreUsuario,
        texto: texto,
        calificacion: calificacion,
      );
      
      // Recargar comentarios después de crear uno nuevo
      await cargarComentariosBySitio(sitioId);
    } catch (e) {
      _errorMessage = 'Error al crear comentario: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> actualizarComentario({
    required String comentarioId,
    required String sitioId,
    required String texto,
    required double calificacion,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _comentarioService.actualizarComentario(
        comentarioId: comentarioId,
        texto: texto,
        calificacion: calificacion,
      );
      
      // Recargar comentarios después de actualizar
      await cargarComentariosBySitio(sitioId);
    } catch (e) {
      _errorMessage = 'Error al actualizar comentario: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarComentario({
    required String comentarioId,
    required String sitioId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _comentarioService.eliminarComentario(comentarioId);
      
      // Recargar comentarios después de eliminar
      await cargarComentariosBySitio(sitioId);
    } catch (e) {
      _errorMessage = 'Error al eliminar comentario: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Comentario>> getComentariosByUsuario(String usuarioId) async {
    try {
      return await _comentarioService.getComentariosByUsuario(usuarioId);
    } catch (e) {
      _errorMessage = 'Error al cargar comentarios del usuario: $e';
      notifyListeners();
      return [];
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearComentarios() {
    _comentarios = [];
    _calificacionPromedio = 0.0;
    notifyListeners();
  }
}
