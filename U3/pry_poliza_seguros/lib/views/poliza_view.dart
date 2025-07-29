import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';
import '../viewmodels/poliza_viewmodel_interfaz.dart';

class PolizaView extends StatefulWidget {
  const PolizaView({Key? key}) : super(key: key);

  @override
  State<PolizaView> createState() => _PolizaViewState();
}

class _PolizaViewState extends State<PolizaView> with TickerProviderStateMixin {
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _propietarioController = TextEditingController();
  final _edadController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late AnimationController _resultController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _resultController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resultController.dispose();
    _valorController.dispose();
    _accidentesController.dispose();
    _propietarioController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PolizaViewModelInterface>(context);

    // Actualizar controladores solo si es necesario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_valorController.text != vm.valorSeguroAuto.toString()) {
        _valorController.text = vm.valorSeguroAuto.toString();
      }
      if (_accidentesController.text != vm.accidentes.toString()) {
        _accidentesController.text = vm.accidentes.toString();
      }
      if (_propietarioController.text != vm.propietario) {
        _propietarioController.text = vm.propietario;
      }
      if (_edadController.text != vm.edadPropietario.toString()) {
        _edadController.text = vm.edadPropietario.toString();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con icono
                  _buildHeader(),
                  const SizedBox(height: 30),

                  // Información del propietario
                  _buildSection(
                    title: 'Información del Propietario',
                    icon: Icons.person_rounded,
                    children: [
                      _buildInput(
                        "Nombre del propietario",
                        _propietarioController,
                        Icons.person_outline_rounded,
                            (val) {
                          vm.propietario = val;
                          vm.notifyListeners();
                        },
                        key: const ValueKey('propietarioInput'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingrese el nombre del propietario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInput(
                        "Edad del propietario",
                        _edadController,
                        Icons.cake_outlined,
                            (val) {
                          vm.edadPropietario = int.tryParse(val) ?? 0;
                          vm.notifyListeners();
                        },
                        keyboard: TextInputType.number,
                        key: const ValueKey('edadPropietarioInput'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingrese la edad';
                          }
                          final edad = int.tryParse(value!);
                          if (edad == null || edad < 18 || edad > 100) {
                            return 'Ingrese una edad válida (18-100)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Información del vehículo
                  _buildSection(
                    title: 'Información del Vehículo',
                    icon: Icons.directions_car_rounded,
                    children: [
                      _buildInput(
                        "Valor del seguro",
                        _valorController,
                        Icons.attach_money_rounded,
                            (val) {
                          vm.valorSeguroAuto = double.tryParse(val) ?? 0;
                          vm.notifyListeners();
                        },
                        keyboard: TextInputType.number,
                        key: const ValueKey('valorSeguroInput'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingrese el valor del seguro';
                          }
                          final valor = double.tryParse(value!);
                          if (valor == null || valor <= 0) {
                            return 'Ingrese un valor válido mayor a 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Selector de modelo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF00C851).withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00C851).withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00C851).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.model_training_rounded,
                                    color: Color(0xFF00C851),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "Modelo del vehículo",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                for (var i = 0; i < ['A', 'B', 'C'].length; i++)
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: i < 2 ? 10 : 0,
                                      ),
                                      child: _buildModelOption(
                                        ['A', 'B', 'C'][i],
                                        vm.modeloAuto,
                                            (val) {
                                          vm.modeloAuto = val!;
                                          vm.notifyListeners();
                                          HapticFeedback.selectionClick();
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Historial de accidentes
                  _buildSection(
                    title: 'Historial de Accidentes',
                    icon: Icons.warning_rounded,
                    children: [
                      _buildInput(
                        "Número de accidentes",
                        _accidentesController,
                        Icons.brush,
                            (val) {
                          vm.accidentes = int.tryParse(val) ?? 0;
                          vm.notifyListeners();
                        },
                        keyboard: TextInputType.number,
                        key: const ValueKey('accidentesInput'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingrese el número de accidentes';
                          }
                          final accidentes = int.tryParse(value!);
                          if (accidentes == null || accidentes < 0) {
                            return 'Ingrese un número válido (0 o mayor)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  // Botón de crear póliza
                  Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF00C851),
                          Color(0xFF00BF63),
                          Color(0xFF00A651),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00C851).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      key: const ValueKey('crearPolizaButton'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          vm.calcularPoliza();
                          _resultController.forward();
                          HapticFeedback.lightImpact();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'CREAR PÓLIZA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Resultado
                  if (vm.costoTotal > 0)
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildResultCard(vm.costoTotal),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00C851),
            Color(0xFF00BF63),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C851).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nueva Póliza',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Complete la información para calcular su seguro',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF00C851).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C851).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF00C851),
                  size: 22,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(
      String label,
      TextEditingController controller,
      IconData icon,
      Function(String) onChanged, {
        TextInputType? keyboard,
        Key? key,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: keyboard,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3E50),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: const Color(0xFF00C851).withOpacity(0.7),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF00C851).withOpacity(0.7),
          size: 22,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFF00C851).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFF00C851).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF00C851),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildModelOption(String model, String groupValue, Function(String?) onChanged) {
    final isSelected = model == groupValue;

    return GestureDetector(
      onTap: () => onChanged(model),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00C851)
              : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00C851)
                : const Color(0xFF00C851).withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          'Modelo $model',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2C3E50),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(double costoTotal) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00C851),
            Color(0xFF00BF63),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C851).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 15),
          const Text(
            '¡Póliza Calculada!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Costo Total del Seguro:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '\$${costoTotal.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}