import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naqliatsa/feature/home/ui/view/home_view.dart';
import '../../../../core/common/widget/bottom_nav_wrapper.dart';
import '../../../../core/common/widget/loading_progress.dart';
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
  // context.read<>()

  void startTimer() {
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      appBar: AppBar(title: Text("Verify")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
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
              spacing: 1,
              mainAxisAlignment: .center,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    "Didn't receive the code?",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const Spacer(),
                Text(
                  formatTime(context.read<AuthCubit>().counter),
                  textAlign: .center,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _canResend
                      ? () async {
                          await context.read<AuthCubit>().sendOTP();
                          startTimer();
                        }
                      : null,
                  child: Text("Resend"),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(
        child: FilledButton(
          onPressed: () async {
            context.read<AuthCubit>().verifyPhone();
          },
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                // الانتقال للشاشة الرئيسية
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeView()),
                );
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error ?? "Verification failed")),
                );
              }
            },
            builder: (_, state) {
              if (state is AuthLoading) return const LoadingProgress();
              return Text("continue".tr());
            },
          ),

          //  BlocConsumer<AuthCubit, AuthState>(
          //   listener: (_, state) {},
          //   builder: (_, state) {
          //     if (state is AuthLoading) return const LoadingProgress();
          //     return Text("continue".tr());
          //   },
          // ),
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    // 00:25
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }
}
