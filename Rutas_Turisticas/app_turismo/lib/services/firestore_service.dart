// Mock service sin Firebase
import '../models/usuario.dart';
import '../models/sitio_turistico.dart';
import '../models/comentario.dart';

class FirestoreService {
  // Datos mock locales
  static final Map<String, Usuario> _usuarios = {};
  static final List<SitioTuristico> _sitios = [
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
    SitioTuristico(
      id: '3',
      nombre: 'Teleférico Quito',
      descripcion: 'Vista panorámica de la ciudad',
      latitud: -0.1807,
      longitud: -78.5158,
    ),
  ];

  // Usuario methods
  Future<void> createUsuario(Usuario usuario) async {
    await Future.delayed(Duration(milliseconds: 500));
    _usuarios[usuario.id] = usuario;
  }

  Future<Usuario?> getUsuario(String userId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _usuarios[userId];
  }

  Future<void> updateFavoritos(String userId, List<String> favoritos) async {
    await Future.delayed(Duration(milliseconds: 300));
    final usuario = _usuarios[userId];
    if (usuario != null) {
      _usuarios[userId] = Usuario(
        id: usuario.id,
        email: usuario.email,
        nombre: usuario.nombre,
        sitiosFavoritos: favoritos,
        fechaRegistro: usuario.fechaRegistro,
      );
    }
  }

  // Sitios methods
  Future<List<SitioTuristico>> getSitios() async {
    await Future.delayed(Duration(milliseconds: 500));
    return List.from(_sitios);
  }

  Future<List<SitioTuristico>> getSitiosByIds(List<String> ids) async {
    await Future.delayed(Duration(milliseconds: 300));
    if (ids.isEmpty) return [];
    
    return _sitios.where((sitio) => ids.contains(sitio.id)).toList();
  }

  // Comentarios methods
  Future<void> addComentario(Comentario comentario) async {
    await Future.delayed(Duration(milliseconds: 300));
    // Mock implementation
  }

  Future<List<Comentario>> getComentariosBySitio(String sitioId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return []; // Mock empty list
  }
}
