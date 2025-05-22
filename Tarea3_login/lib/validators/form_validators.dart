// lib/validators/form_validators.dart

class FormValidators {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'El usuario es obligatorio';
    }
    if (value.length < 4) {
      return 'El usuario debe tener al menos 4 caracteres';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es obligatorio';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es obligatorio';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'El número debe tener exactamente 10 dígitos numéricos';
    }
    return null;
  }

  static String? validateText(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.length < 2) return 'Debe tener al menos 2 letras';

    final regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!regex.hasMatch(value)) return 'Solo se permiten letras';

    return null;
  }





  static final Map<String, String> _postalCodeMap = {
  '010150': 'Azuay',
  '020150': 'Bolívar',
  '030150': 'Cañar',
  '040150': 'Carchi',
  '050150': 'Chimborazo',
  '060150': 'Cotopaxi',
  '070150': 'El Oro',
  '080150': 'Esmeraldas',
  '090150': 'Guayas',
  '100150': 'Imbabura',
  '110150': 'Loja',
  '120150': 'Los Ríos',
  '130150': 'Manabí',
  '140150': 'Morona Santiago',
  '150150': 'Napo',
  '160150': 'Pastaza',
  '170150': 'Pichincha',
  '180150': 'Tungurahua',
  '190150': 'Zamora Chinchipe',
  '200150': 'Galápagos',
  '210150': 'Sucumbíos',
  '220150': 'Orellana',
  '230150': 'Santo Domingo de los Tsáchilas',
  '240150': 'Santa Elena',
  };

  /// Validación de código postal (campo obligatorio y válido en Ecuador)
  static String? validatePostalCode(String? value) {
  if (value == null || value.isEmpty) return 'Campo requerido';
  if (!_postalCodeMap.containsKey(value)) return 'Código postal inválido en Ecuador';
  return null;
  }


  static String? getProvinceByPostalCode(String value) {
  return _postalCodeMap[value];
  }


  static String? validateTextCodePostal(String? value) {
  if (value == null || value.isEmpty) return 'Campo requerido';
  if (value.length < 2) return 'Debe tener al menos 2 letras';
  final regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
  if (!regex.hasMatch(value)) return 'Solo se permiten letras';
  return null;
  }
  }



