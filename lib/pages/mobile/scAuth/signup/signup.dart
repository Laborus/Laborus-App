import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/components/navigation/custom_app_bar_introduction.dart';
import 'package:laborus_app/core/providers/signup_provider.dart';
import 'package:laborus_app/core/routes/app_route_enum.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/pages/mobile/scAuth/signup/steps/details_account_step.dart';
import 'package:laborus_app/pages/mobile/scAuth/signup/steps/info_institution_step.dart';
import 'package:laborus_app/pages/mobile/scAuth/signup/steps/widgets/build_progress_indicator.dart';
import 'package:provider/provider.dart';

class SignupWrapper extends StatefulWidget {
  const SignupWrapper({super.key});

  @override
  State<SignupWrapper> createState() => _SignupWrapperState();
}

class _SignupWrapperState extends State<SignupWrapper> {
  final Map<int, Widget> _steps = {
    1: const DetailsAccountStep(),
    2: const InfoInstitutionStep(),
  };

  final Map<int, String> _stepTitles = {
    1: 'Dados Obrigatórios',
    2: 'Instituição',
  };

  int _currentStep = 1;
  late final SignupProvider _signupProvider;

  @override
  void initState() {
    super.initState();
    _signupProvider = Provider.of<SignupProvider>(context, listen: false);
  }

  Future<void> _handleSubmit() async {
    if (!_signupProvider.validateInstitutionStep()) {
      _showErrorSnackBar('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    final success = await _signupProvider.signup();
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: AppColors.green,
          ),
        );
        _signupProvider.reset();
        context.go(AppRouteEnum.signin.name);
      }
    } else {
      final errorMessage = _signupProvider.errors['submit'] ??
          'Falha ao criar conta. Tente novamente.';
      stderr.writeln(errorMessage);
      if (mounted) {
        _showErrorSnackBar(errorMessage);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _signupProvider.validateDetailsStep();
      case 2:
        return _signupProvider.validateInstitutionStep();
      default:
        return false;
    }
  }

  void _handleNextStep() {
    if (!_validateCurrentStep()) {
      _showErrorSnackBar('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    if (_currentStep < _steps.length) {
      setState(() {
        _currentStep++;
      });
    } else {
      _handleSubmit();
    }
  }

  void _handleBackStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: CustomAppBarIntroduction(
            title: _stepTitles[_currentStep] ?? '',
            onBack: _handleBackStep,
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Scrollbar(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          expandedHeight: 40,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          automaticallyImplyLeading: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Etapa $_currentStep de ${_steps.length}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                BuildProgressIndicator(
                                  step: _currentStep,
                                  remainingSteps: _steps.length - _currentStep,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _steps[_currentStep] ?? const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (provider.isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        if (provider.loadingMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              provider.loadingMessage!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).colorScheme.primary,
            height: 140,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: provider.isLoading ? null : _handleNextStep,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .8,
                    alignment: Alignment.center,
                    child: Text(
                      _currentStep == _steps.length
                          ? 'Criar Conta'
                          : 'Continuar',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já possui uma conta?',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRouteEnum.signin.name),
                      child: Text(
                        'Faça login!',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
