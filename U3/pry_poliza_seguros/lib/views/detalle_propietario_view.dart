import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/detalle_propietario_viewmodel.dart';
import '../models/propietario_model.dart';

class DetallePropietarioView extends StatelessWidget {
  final Propietario propietario;

  const DetallePropietarioView({Key? key, required this.propietario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetallePropietarioViewModel()..cargarDetallePorUsuario(propietario.id),
      child: _DetallePropietarioContent(propietario: propietario),
    );
  }
}

class _DetallePropietarioContent extends StatefulWidget {
  final Propietario propietario;

  const _DetallePropietarioContent({required this.propietario});

  @override
  State<_DetallePropietarioContent> createState() => _DetallePropietarioContentState();
}

class _DetallePropietarioContentState extends State<_DetallePropietarioContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardController;
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

    _cardController = AnimationController(
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
      parent: _cardController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              // App Bar personalizado
              _buildCustomAppBar(),

              // Contenido principal
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Consumer<DetallePropietarioViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading) {
                        return _buildLoadingState();
                      } else if (viewModel.error != null) {
                        return _buildErrorState(viewModel.error!);
                      } else if (viewModel.detalle == null) {
                        return _buildEmptyState();
                      }

                      // Activar animación cuando se cargan los datos
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!_cardController.isCompleted) {
                          _cardController.forward();
                        }
                      });

                      final d = viewModel.detalle!;
                      return ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          children: [
                            // Información del propietario
                            _buildOwnerInfoCard(),
                            const SizedBox(height: 20),

                            // Información del vehículo
                            _buildVehicleInfoCard(d),
                            const SizedBox(height: 20),

                            // Información del seguro
                            _buildInsuranceInfoCard(d),
                            const SizedBox(height: 20),

                            // Resumen financiero
                            _buildFinancialSummaryCard(d),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SliverAppBar.large(
      expandedHeight: 160.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF00C851),
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.propietario.nombreCompleto,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00C851),
                Color(0xFF00BF63),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 80,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF00C851).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00C851)),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Cargando información...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7B8794),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.red.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red.shade400,
              size: 50,
            ),
            const SizedBox(height: 15),
            const Text(
              'Error al cargar información',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              color: Colors.grey.shade400,
              size: 50,
            ),
            const SizedBox(height: 15),
            const Text(
              'Sin información',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'No se encontró información para este propietario',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerInfoCard() {
    return Container(
      width: double.infinity,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C851).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF00C851),
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'Información del Propietario',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            'Nombre Completo',
            widget.propietario.nombreCompleto,
            Icons.badge_rounded,
          ),
          const SizedBox(height: 15),
          _buildInfoRow(
            'ID del Usuario',
            widget.propietario.id.toString(),
            Icons.fingerprint_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfoCard(dynamic detalle) {
    return Container(
      width: double.infinity,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C851).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: Color(0xFF00C851),
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'Información del Vehículo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            'Modelo del Auto',
            'Modelo ${detalle.modeloAuto}',
            Icons.model_training_rounded,
          ),
          const SizedBox(height: 15),
          _buildInfoRow(
            'Edad del Propietario',
            '${detalle.edadPropietario} años',
            Icons.cake_rounded,
          ),
          const SizedBox(height: 15),
          _buildInfoRow(
            'Historial de Accidentes',
            '${detalle.accidentes} accidente${detalle.accidentes != 1 ? 's' : ''}',
            Icons.warning_rounded,
            valueColor: detalle.accidentes > 0 ? Colors.orange : const Color(0xFF00C851),
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceInfoCard(dynamic detalle) {
    return Container(
      width: double.infinity,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C851).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: Color(0xFF00C851),
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'Información del Seguro',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            'Valor del Seguro',
            '\$${detalle.valorSeguroAuto.toStringAsFixed(2)}',
            Icons.attach_money_rounded,
            valueColor: const Color(0xFF00C851),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummaryCard(dynamic detalle) {
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
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Costo Total del Seguro',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${detalle.costoTotal.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Precio final calculado',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF00C851).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF00C851),
            size: 18,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? const Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}