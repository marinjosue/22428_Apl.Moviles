import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/location_datasource.dart';
import 'data/repositories/location_repository_impl.dart';
import 'application/usecases/location_usecase.dart';
import 'presentation/providers/location_provider.dart';
import 'presentation/views/map_view.dart';

void main() {
  final dataSource = LocationDataSource();
  final repository = LocationRepositoryImpl(dataSource);
  final useCase = LocationUseCase(repository);

  runApp(MyApp(useCase: useCase));
}

class MyApp extends StatelessWidget {
  final LocationUseCase useCase;
  const MyApp({super.key, required this.useCase});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = LocationProvider(useCase);
        provider.startListening();
        return provider;
      },
      child: MaterialApp(
        title: 'App de Geolocalización',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MapView(),
      ),
    );
  }
}
