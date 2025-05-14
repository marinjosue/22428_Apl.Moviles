import 'package:flutter/material.dart';
import '../controllers/year_controller.dart';
import '../themes/text_styles.dart';

class Result extends StatelessWidget {
  final controller = YearController();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int year = arguments['year'] as int;
    final orientation = MediaQuery.of(context).orientation;
    final list = controller.getLast(year);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de años bisiestos',
          style: AppTextStyles.headline1,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final y = list[index];
            return Card(
              child: ListTile(
                title: Text('Año: $y'),
                trailing: y == year
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}