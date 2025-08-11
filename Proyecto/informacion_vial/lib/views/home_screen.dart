import 'package:flutter/material.dart';
import '../views/scan_screen.dart';
import '../views/chat_screen.dart';
import '../views/history_screen.dart';
import '../views/informacion_vial_screen.dart';
import '../views/editar_perfil_screen.dart';
import '../utils/constants.dart';
import '../models/traffic_sign.dart';
import '../services/user_service.dart';

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
        child: Column(
          children: [
            // Header del drawer con gradiente
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kPrimaryColor,
                    kPrimaryColor.withOpacity(0.8),
                    kPrimaryColor.withOpacity(0.6),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar del usuario con efecto
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Información del usuario
                      Text(
                        UserService.instance.currentUser?.name ?? 'Usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        UserService.instance.currentUser?.email ?? 'email@ejemplo.com',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        kAppName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Opciones del menú
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    _buildDrawerItem(
                      icon: Icons.history,
                      title: 'Historial',
                      isSelected: _currentIndex == 2,
                      onTap: () {
                        setState(() => _currentIndex = 2);
                        Navigator.pop(context);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.edit,
                      title: 'Editar Perfil',
                      isSelected: false,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditarPerfilScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.info,
                      title: 'Información Vial',
                      isSelected: false,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InformacionVialScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 20),
                    _buildDrawerItem(
                      icon: Icons.exit_to_app,
                      title: 'Salir',
                      isSelected: false,
                      isExit: true,
                      onTap: () async {
                        Navigator.pop(context);
                        await UserService.instance.logout();
                        Navigator.pushReplacementNamed(context, kRouteLogin);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey.shade600,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          iconSize: 24,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _currentIndex == 0 
                      ? kPrimaryColor.withOpacity(0.15) 
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: _currentIndex == 0 
                      ? kPrimaryColor 
                      : Colors.grey.shade600,
                ),
              ),
              label: 'Escaneo',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _currentIndex == 1 
                      ? kPrimaryColor.withOpacity(0.15) 
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.chat,
                  color: _currentIndex == 1 
                      ? kPrimaryColor 
                      : Colors.grey.shade600,
                ),
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _currentIndex == 2 
                      ? kPrimaryColor.withOpacity(0.15) 
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.history,
                  color: _currentIndex == 2 
                      ? kPrimaryColor 
                      : Colors.grey.shade600,
                ),
              ),
              label: 'Historial',
            ),
          ],
        ),
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool isExit = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: isExit 
              ? Colors.red.withOpacity(0.2) 
              : kPrimaryColor.withOpacity(0.2),
          highlightColor: isExit 
              ? Colors.red.withOpacity(0.1) 
              : kPrimaryColor.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
              border: isSelected 
                  ? Border.all(color: kPrimaryColor.withOpacity(0.3), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected 
                        ? kPrimaryColor
                        : isExit 
                            ? Colors.red.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected 
                        ? Colors.white
                        : isExit 
                            ? Colors.red
                            : Colors.grey.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected 
                          ? kPrimaryColor
                          : isExit 
                              ? Colors.red
                              : Colors.grey.shade800,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
