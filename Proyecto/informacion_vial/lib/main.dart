import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/scan_viewmodel.dart';
import 'viewmodels/chat_viewmodel.dart';
import 'viewmodels/history_viewmodel.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/home_screen.dart';
import 'views/chat_screen.dart';
import 'views/realtime_detection_screen.dart';
import 'utils/constants.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar usuario guardado
  await UserService.instance.loadUser();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ScanViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asistente Vial',
      initialRoute: UserService.instance.isLoggedIn ? kRouteHome : kRouteLogin,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: true,
      ),
      routes: {
        kRouteLogin: (context) => LoginScreen(),
        kRouteRegister: (context) => RegisterScreen(),
        kRouteHome: (context) => HomeScreen(),
        kRouteScan: (context) => RealtimeDetectionScreen(),
        kRouteChat: (context) => ChatScreen(),
      },
    );
  }
}
