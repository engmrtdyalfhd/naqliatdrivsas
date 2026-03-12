import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:naqliatdrivsas/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:naqliatdrivsas/feature/auth/presentation/widget/counterCodePicker.dart';
import 'package:naqliatdrivsas/feature/auth/presentation/view/verify_phone_view.dart'
    show VerifyPhoneView;

import '../../../../core/common/widget/bottom_nav_wrapper.dart';
import '../../../../core/common/widget/input.dart';
import '../../../../core/common/widget/loading_progress.dart';
import '../../../../core/helper/constant.dart';
import '../../../../core/helper/extension.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String _countryCode = '+966';
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (_, state) => state is OtpSentState || state is AuthFailure,
      listener: (context, state) {
        if (state is OtpSentState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AuthCubit>(),
                child: const VerifyPhoneView(),
              ),
            ),
          );
        } else if (state is AuthFailure) {
          context.simpleDialog(msg: state.message, lottie: ImgPath.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('login'.tr())),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'login_hint1'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text('login_hint2'.tr()),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'country'.tr(),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (_, state) => state is AuthLoading || state is AuthInitial,
                          builder: (context, state) {
                            return CountryCodePicker(
                              selectedCode: _countryCode,
                              onTap: state is AuthLoading
                                  ? null
                                  : () async {
                                final code =
                                await showModalBottomSheet<String>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) =>
                                  const CountryCodeBottomSheet(),
                                );
                                if (code != null) {
                                  setState(() => _countryCode = code);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'phone'.tr(),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Form(
                            key: _formKey,
                            autovalidateMode: _autovalidate,
                            child: Input(
                              controller: _controller,
                              validator: _validatePhone,
                              hint: 'phone_number'.tr(),
                              prefix: Iconsax.mobile,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavWrapper(
          child: FilledButton(
            onPressed: () => _onContinue(context),
            child: BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (_, state) =>
              state is AuthLoading || state is AuthInitial || state is AuthFailure,
              builder: (_, state) {
                if (state is AuthLoading) return const LoadingProgress();
                if (state is AuthSuccess) Navigator.of(context).pushNamed(RoutePath.collection);
                return Text('continue'.tr());
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onContinue(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.always);
      return;
    }
    context.read<AuthCubit>().phone = '$_countryCode${_controller.text}';
    await context.read<AuthCubit>().sendOtp();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^[1-9][0-9]{7,14}$').hasMatch(value)) {
      return 'Enter number without leading 0 or + (8–15 digits)';
    }
    return null;
  }
}