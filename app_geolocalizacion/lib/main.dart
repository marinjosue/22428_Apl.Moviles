import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'data/datasources/location_datasource.dart';
import 'data/repositories/location_repository_impl.dart';
import 'application/usecases/location_usecase.dart';
import 'presentation/providers/location_provider.dart';
import 'presentation/views/map_view.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Optimize UI performance
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  
  // Initialize dependencies
  final dataSource = LocationDataSource();
  final repository = LocationRepositoryImpl(dataSource);
  final useCase = LocationUseCase(repository);
  final provider = LocationProvider(useCase);

  runApp(MyApp(provider: provider, dataSource: dataSource));
}

class MyApp extends StatefulWidget {
  final LocationProvider provider;
  final LocationDataSource dataSource;
  
  const MyApp({
    super.key, 
    required this.provider,
    required this.dataSource,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Start location services after UI is built
    Future.delayed(Duration.zero, () {
      widget.provider.startListening();
    });
  }
  
  @override
  void dispose() {
    widget.dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.provider,
      child: MaterialApp(
        title: 'App de Geolocalización',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MapView(),
      ),
    );
  }
}
