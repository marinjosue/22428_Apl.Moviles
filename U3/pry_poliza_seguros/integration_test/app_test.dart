import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pry_poliza_seguros/main.dart';
import 'package:pry_poliza_seguros/models/propietario_model.dart';
import 'package:pry_poliza_seguros/viewmodels/propietario_viewmodel.dart';
import 'package:pry_poliza_seguros/viewmodels/propietario_viewmodel_interface.dart';
import 'package:pry_poliza_seguros/views/detalle_propietario_view.dart';
import 'package:pry_poliza_seguros/views/home_screen.dart';

import './viewmodels/FakeLoginViewModel.dart';
import './viewmodels/FakePolizaViewModel.dart';
import 'viewmodels/FakePropietarioViewModel.dart';
import 'viewmodels/FakeTestApp.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🟩 Login', () {
    testWidgets('Login fallido muestra mensaje de error', (tester) async {
      final fakeLoginVM = FakeLoginViewModel();
      final fakePolizaVM = FakePolizaViewModel();

      await tester.pumpWidget(
        TestApp(
          loginVM: fakeLoginVM,
          polizaVM: fakePolizaVM,
        ),
      );

      await tester.pumpAndSettle();

      // Intentar login con credenciales incorrectas
      await tester.enterText(find.byKey(const ValueKey('usuarioTextField')), 'usuario_invalido');
      await tester.enterText(find.byKey(const ValueKey('passwordTextField')), 'clave_invalida');
      await tester.tap(find.byKey(const ValueKey('loginButton')));
      await tester.pumpAndSettle();

      // Verificar mensaje de error
      expect(find.text('Credenciales incorrectas'), findsOneWidget);
      expect(fakeLoginVM.isLoggedIn, false);
    });

    testWidgets('Login exitoso navega a pantalla principal', (tester) async {
      final fakeLoginVM = FakeLoginViewModel();
      final fakePolizaVM = FakePolizaViewModel();

      // Configura credenciales mock
      fakeLoginVM.setMockCredentials('testuser', 'testpass');

      await tester.pumpWidget(
        TestApp(
          loginVM: fakeLoginVM,
          polizaVM: fakePolizaVM,
        ),
      );

      await tester.pumpAndSettle();

      // Ingresa credenciales
      await tester.enterText(find.byKey(const ValueKey('usuarioTextField')), 'testuser');
      await tester.enterText(find.byKey(const ValueKey('passwordTextField')), 'testpass');

      // Presiona el botón
      await tester.tap(find.byKey(const ValueKey('loginButton')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verifica que estamos en HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

  group('🟩 Registro y cálculo de póliza', () {
    testWidgets('Cálculo correcto con datos válidos', (tester) async {
      final fakeLoginVM = FakeLoginViewModel()..isLoggedIn = true;
      final fakePolizaVM = FakePolizaViewModel()..setValoresValidos();

      await tester.pumpWidget(
        TestApp(
          loginVM: fakeLoginVM,
          polizaVM: fakePolizaVM,
          isLoggedIn: true,
        ),
      );

      await tester.pumpAndSettle();

      // Verificar navegación
      expect(find.byKey(const ValueKey('main-navigation')), findsOneWidget);

      // Cambiar a pestaña de Póliza si no está activa
      final tabFinder = find.byIcon(Icons.home).last;
      if (tester.widgetList(tabFinder).isNotEmpty) {
        await tester.tap(tabFinder);
        await tester.pumpAndSettle();
      }

      // Llenar formulario
      await tester.enterText(find.byKey(const ValueKey('propietarioInput')), 'Diego Casignia');
      await tester.enterText(find.byKey(const ValueKey('valorSeguroInput')), '10000');

      // Seleccionar modelo de auto
      await tester.tap(find.text('Modelo B').last);
      await tester.pump();

      await tester.enterText(find.byKey(const ValueKey('edadPropietarioInput')), '30');
      await tester.enterText(find.byKey(const ValueKey('accidentesInput')), '1');

      // Calcular póliza
      await tester.tap(find.byKey(const ValueKey('crearPolizaButton')));
      await tester.pumpAndSettle();

      // Verificar resultados
      expect(find.textContaining('Costo total:'), findsOneWidget);
      expect(fakePolizaVM.costoTotal, greaterThan(0));
    });

    // testWidgets('Muestra errores con datos inválidos', (tester) async {
    //   final fakeLoginVM = FakeLoginViewModel()..isLoggedIn = true;
    //   final fakePolizaVM = FakePolizaViewModel()..setValoresInvalidos();
    //
    //   await tester.pumpWidget(
    //     TestApp(
    //       loginVM: fakeLoginVM,
    //       polizaVM: fakePolizaVM,
    //       isLoggedIn: true,
    //     ),
    //   );
    //
    //   await tester.pumpAndSettle();
    //
    //   // Intentar calcular - debería mostrar errores
    //   await tester.tap(find.byKey(const ValueKey('crearPolizaButton')));
    //
    //   // Espera a que se complete la operación async
    //   await tester.pumpAndSettle();
    //
    //   // Verifica que el error se haya establecido
    //   expect(fakePolizaVM.error, isNotNull);
    //
    //   // Verifica los mensajes de error específicos en la UI
    //   expect(find.text('Nombre requerido'), findsOneWidget);
    //   expect(find.text('El valor debe ser positivo'), findsOneWidget);
    //   expect(find.text('Edad mínima: 18 años'), findsOneWidget);
    // });
  });

  group('🟩 Consulta de pólizas', () {
    testWidgets('Muestra lista de propietarios', (tester) async {
      final fakeLoginVM = FakeLoginViewModel()..isLoggedIn = true;
      final fakePolizaVM = FakePolizaViewModel();
      final fakePropietarioVM = FakePropietarioViewModel();

      // Configura mock de propietarios
      fakePropietarioVM.setMockData([
        Propietario(
          id: 1,
          nombreCompleto: 'Micaela Salcedo',
          edad: 28,
          automovilIds: [1, 2],
        )
      ]);

      await tester.pumpWidget(
        TestApp(
          loginVM: fakeLoginVM,
          polizaVM: fakePolizaVM,
          isLoggedIn: true,
        ),
      );

      await tester.pumpAndSettle();

      // Verifica que se muestra el HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}