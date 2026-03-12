import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naqliatdrivsas/feature/auth/presentation/widget/otp_input.dart' show OtpInput;

import '../../../../core/common/widget/bottom_nav_wrapper.dart';
import '../../../../core/common/widget/loading_progress.dart';
import '../../../../core/helper/constant.dart';
import '../../../../core/helper/extension.dart';
import '../../presentation/cubit/auth_cubit.dart';

class VerifyPhoneView extends StatefulWidget {
  const VerifyPhoneView({super.key});

  @override
  State<VerifyPhoneView> createState() => _VerifyPhoneViewState();
}

class _VerifyPhoneViewState extends State<VerifyPhoneView> {
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _canResend = false);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final cubit = context.read<AuthCubit>();
      if (cubit.resendCountdown <= 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => cubit.resendCountdown--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (_, state) =>
      state is AuthSuccess || state is AuthFailure,
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.pushNamedAndRemoveUntil(
            RoutePath.authGate,
                (_) => false,
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Verify')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter OTP verification code',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              Text('The code has been sent to\n${cubit.phone}'),
              const SizedBox(height: 32),
              const OtpInput(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    flex: 3,
                    child: Text(
                      "Didn't receive the code?",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(cubit.resendCountdown),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _canResend
                        ? () async {
                      await cubit.sendOtp();
                      _startTimer();
                    }
                        : null,
                    child: const Text('Resend'),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavWrapper(
          child: FilledButton(
            onPressed: () => cubit.verifyOtp(),
            child: BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (_, state) =>
              state is AuthLoading ||
                  state is AuthInitial ||
                  state is AuthFailure ||
                  state is AuthSuccess,
              builder: (_, state) {
                if (state is AuthLoading) return const LoadingProgress();
                return Text('continue'.tr());
              },
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}