import 'package:flutter/material.dart';
import '../views/scan_screen.dart';
import '../views/chat_screen.dart';
import '../views/history_screen.dart';
import '../utils/constants.dart';
import '../models/traffic_sign.dart';
import '../services/user_service.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  TrafficSign? _chatSignal;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Obtener argumentos si los hay
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _chatSignal = args['chatSignal'] as TrafficSign?;
      final initialTab = args['initialTab'] as int?;
      if (initialTab != null) {
        setState(() {
          _currentIndex = initialTab;
        });
      }
    }
  }

  List<Widget> get _screens => [
    ScanScreen(),
    ChatScreen(initialSignal: _chatSignal),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: kPrimaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kAppName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tu asistente para señales de tránsito',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Escaneo de señales'),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat informativo'),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historial'),
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
              onTap: () async {
                Navigator.pop(context);
                await UserService.instance.logout();
                Navigator.pushReplacementNamed(context, kRouteLogin);
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Escaneo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Escaneo de Señales';
      case 1:
        return 'Chat Informativo';
      case 2:
        return 'Historial de Consultas';
      default:
        return kAppName;
    }
  }
}
