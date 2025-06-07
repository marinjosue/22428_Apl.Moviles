import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/login_model.dart';

class RegistrationController {
  Future<void> saveUser(UsuarioModel user) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/users.txt';
    final file = File(path);

    await file.writeAsString('${user.toCsv()}\n', mode: FileMode.append);
  }
}
