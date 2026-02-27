import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:naqliatsa/feature/auth/ui/view/verify_phone_view.dart';
import '../../../../core/common/widget/input.dart';
import '../../../../core/common/widget/loading_progress.dart';
import '../../../../core/helper/constant.dart';
import '../../../../core/helper/extension.dart';
import '../../manager/auth_cubit.dart';
import '../widget/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/common/widget/bottom_nav_wrapper.dart';

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
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("login".tr())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              Text(
                "login_hint1".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              Text("login_hint2".tr()),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: .start,
                spacing: 9,
                children: [
                  Column(
                    spacing: 6,
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        "country".tr(),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      CountryCodePicker(
                        selectedCode: _countryCode,
                        onTap: context.read<AuthCubit>().state is AuthLoading
                            ? null
                            : () async {
                                final code = await showModalBottomSheet<String>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) =>
                                      const CountryCodeBottomSheet(),
                                );

                                if (code != null) {
                                  setState(() {
                                    _countryCode = code;
                                  });
                                }
                              },
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      spacing: 6,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "phone".tr(),
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
          onPressed: () async => _sendOTP(context),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (_, state) {
              if (state is CodeSentState) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<AuthCubit>(),
                        child: const VerifyPhoneView(),
                      );
                    },
                  ),
                );
              } else if (state is AuthFailure) {
                context.simpleDialog(msg: state.error, lottie: ImgPath.error);
              } else if (state is AuthSuccess) {
                context.pushNamedAndRemoveUntil(
                  RoutePath.authGate,
                  (_) => false,
                );
              }
            },
            builder: (_, state) {
              if (state is AuthLoading) {
                return const LoadingProgress();
              }
              return Text("continue".tr());
            },
          ),
        ),
      ),
    );
  }

  Future<void> _sendOTP(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().phone = "$_countryCode${_controller.text}";
      await context.read<AuthCubit>().sendOTP();
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.always;
      });
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Regex breakdown:
    // ^        : Start of string
    // [1-9]    : First digit must be 1-9 (no leading 0)
    // [0-9]{7,14} : Followed by 7 to 14 more digits (total length 8-15)
    // $        : End of string
    if (!RegExp(r'^[1-9][0-9]{7,14}$').hasMatch(value)) {
      return 'Enter number without leading 0 or + (8-15 digits)';
    }

    return null;
  }
}
