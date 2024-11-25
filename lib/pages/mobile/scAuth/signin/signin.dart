import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/components/forms/text_field_form.dart';
import 'package:laborus_app/core/components/navigation/custom_app_bar_introduction.dart';
import 'package:laborus_app/core/providers/signin_provider.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/routes/app_route_enum.dart';
import 'package:laborus_app/core/utils/constants/validators.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/pages/mobile/scIntroduction/welcome/widgets/build_text_section.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<SigninProvider>();

      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (success) {
          final userProvider = context.read<UserProvider>();
          try {
            await userProvider.initializeUser();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login realizado com sucesso!'),
                backgroundColor: AppColors.green,
                duration: Duration(seconds: 3),
              ),
            );
            context.go(AppRouteEnum.home.name);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao buscar informações do usuário: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? 'Erro desconhecido'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: const CustomAppBarIntroduction(
        title: 'Entre com sua conta',
      ),
      body: Consumer<SigninProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTextSection(context),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Seu e-mail',
                        hintText: 'Digite seu e-mail',
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !authProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Digite sua senha',
                        labelText: 'Sua senha',
                        obscureText: !_isPasswordVisible,
                        validator: Validators.validatePassword,
                        enabled: !authProvider.isLoading,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleSignIn,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 22,
                      child: authProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const Text(
                              'Entrar',
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
