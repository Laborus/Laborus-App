import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/providers/step_provide.dart';
import 'package:provider/provider.dart';
class StepPage3 extends StatelessWidget {
  const StepPage3({super.key});

  @override
  Widget build(BuildContext context) {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StepProvider>(context, listen: false)
          .changeText('Localização e Instituição');
    });
    return ElevatedButton(
      onPressed: () {
        Provider.of<StepProvider>(context, listen: false).addData();
        context.goNamed('signinStep4');
      },
      child: Text('4'),
    );
  }
}
