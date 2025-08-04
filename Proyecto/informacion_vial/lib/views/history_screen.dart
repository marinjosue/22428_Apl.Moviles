import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_viewmodel.dart';
import '../utils/constants.dart';
import '../utils/date_format.dart';
import '../services/user_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryViewModel>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HistoryViewModel>(context);
    final user = UserService.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No hay usuario logueado'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, kRouteLogin);
                },
                child: Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await vm.loadHistory();
        },
        child: vm.isLoading
            ? Center(child: CircularProgressIndicator())
            : vm.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text('Error: ${vm.error}'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => vm.loadHistory(),
                          child: Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : vm.history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay consultas en el historial',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Realiza tu primera consulta en el chat',
                              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: vm.history.length,
                        itemBuilder: (context, idx) {
                          final item = vm.history[idx];
                          final hasSignal = item['signal'] != null;
                          
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: hasSignal ? kPrimaryColor : Colors.grey[400],
                                child: Icon(
                                  hasSignal ? Icons.traffic : Icons.help_outline,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                item['question'] ?? 'Sin pregunta',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (hasSignal) ...[
                                    SizedBox(height: 4),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Señal: ${item['signal']['name'] ?? 'N/A'}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 4),
                                  Text(
                                    formatDate(DateTime.parse(item['timestamp'])),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Mostrar diálogo con la respuesta completa
                                _showResponseDialog(context, item);
                              },
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  void _showResponseDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Respuesta del Asistente'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pregunta:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(item['question'] ?? 'Sin pregunta'),
              SizedBox(height: 16),
              Text(
                'Respuesta:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(item['response'] ?? 'Sin respuesta'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
