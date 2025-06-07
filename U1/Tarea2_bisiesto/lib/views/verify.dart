import 'package:flutter/material.dart';
import '../controllers/year_controller.dart';
import '../themes/button_styles.dart';
import '../themes/app_themes.dart';
import '../themes/text_styles.dart';

class Verify extends StatelessWidget {
  TextEditingController _yearC = TextEditingController();
  YearController controller = YearController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verificar el año bisiesto',
          style: AppTextStyles.headline1,
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _yearC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ingresar un año'
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyles.primary,
              onPressed: (){
                final year = int.parse(_yearC.text);
                if (year == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                      AppThemes.snackBar('Año no valido')
                  );
                  return;
                }
                final isBisiesto = controller.verifyBisiesto(year);
                if(!isBisiesto){
                  ScaffoldMessenger.of(context).showSnackBar(
                      AppThemes.snackBar('El año $year no es bisiesto')
                  );
                  return;
                }
                Navigator.pushNamed(
                  context,
                  '/result',
                  arguments: {'year': year},
                );
              },
              child: Text(
                'Verificar',
                style: AppTextStyles.buttonText,
              ),
            )
          ],
        )
      ),
    );
  }
}