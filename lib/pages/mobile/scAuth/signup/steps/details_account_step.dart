import 'package:flutter/material.dart';
import 'package:laborus_app/core/components/forms/text_field_form.dart';
import 'package:laborus_app/core/providers/signup_provider.dart';
import 'package:laborus_app/core/utils/constants/signup_validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class DetailsAccountStep extends StatefulWidget {
  const DetailsAccountStep({super.key});

  @override
  _DetailsAccountStepState createState() => _DetailsAccountStepState();
}

class _DetailsAccountStepState extends State<DetailsAccountStep> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Dados obrigatórios',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onTertiary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Por favor, preencha os campos com suas informações pessoais.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onTertiary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 15),
          CustomTextField(
            labelText: 'Nome',
            hintText: 'Nome Completo',
            onChanged: provider.setName,
            initialValue: provider.name,
            validator: SignupValidation.validateName,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            labelText: 'CPF',
            hintText: '000.000.000-00',
            onChanged: provider.setCpf,
            initialValue: provider.cpf,
            validator: SignupValidation.validateCPF,
            keyboardType: TextInputType.number,
            maskFormatter: cpfMaskFormatter,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            labelText: 'Email',
            hintText: 'exemplo@gmail.com',
            onChanged: provider.setEmail,
            initialValue: provider.email,
            validator: SignupValidation.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            labelText: 'Senha',
            hintText: 'Sua senha',
            obscureText: !_isPasswordVisible,
            onChanged: provider.setPassword,
            initialValue: provider.password,
            validator: SignupValidation.validatePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(height: 15),
          CustomTextField(
            labelText: 'Confirme sua senha',
            hintText: 'Digite sua senha novamente',
            obscureText: !_isConfirmPasswordVisible,
            onChanged: provider.setConfirmPassword,
            initialValue: provider.confirmPassword,
            validator: (value) => SignupValidation.validateConfirmPassword(
              value,
              provider.password,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
