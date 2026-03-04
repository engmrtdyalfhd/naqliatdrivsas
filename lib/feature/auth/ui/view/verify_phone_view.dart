import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/widget/bottom_nav_wrapper.dart';
import '../../../../core/common/widget/loading_progress.dart';
import '../../../../core/helper/constant.dart';
import '../../../../core/helper/extension.dart';
import '../../manager/auth_cubit.dart';
import '../widget/otp_input.dart';

class VerifyPhoneView extends StatefulWidget {
  const VerifyPhoneView({super.key});

  @override
  State<VerifyPhoneView> createState() => _VerifyPhoneViewState();
}

class _VerifyPhoneViewState extends State<VerifyPhoneView> {
  Timer? _timer;
  bool _canResend = false;

  void startTimer() {
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (context.read<AuthCubit>().counter == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          context.read<AuthCubit>().counter--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter OTP verification code",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3),
            Text(
              "The code has been sent to\n${context.read<AuthCubit>().phone}",
            ),
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
                  formatTime(context.read<AuthCubit>().counter),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _canResend
                      ? () async {
                    await context.read<AuthCubit>().sendOTP();
                    startTimer();
                  }
                      : null,
                  child: const Text("Resend"),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(
        child: FilledButton(
          onPressed: () => context.read<AuthCubit>().verifyPhone(),
          child: BlocConsumer<AuthCubit, AuthState>(
            // Only listen for terminal states — ignore CodeSentState (resend)
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
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            // Only rebuild the button for loading/non-loading states
            buildWhen: (_, state) =>
            state is AuthLoading ||
                state is AuthInitial ||
                state is AuthFailure ||
                state is AuthSuccess,
            builder: (_, state) {
              if (state is AuthLoading) return const LoadingProgress();
              return Text("continue".tr());
            },
          ),
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }
}