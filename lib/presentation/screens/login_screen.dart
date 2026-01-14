import 'package:empiricus_app_dev_beatriz_dadalto/core/utils/snackbar_utils.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/app_router.dart';
import '../widgets/login/login_form.dart';
import '../widgets/login/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState is AuthSuccess) {
            context.go(AppRouter.subscriptions);
          } else if (authState is AuthFailure) {
            SnackbarUtils.showError(context, authState.message);
          }
        },
        builder: (context, authState) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoginHeader(),
                  const SizedBox(height: 48),
                  const LoginForm(),
                  if (authState is AuthFailure) ...[
                    const SizedBox(height: 16),
                    Text(
                      authState.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
