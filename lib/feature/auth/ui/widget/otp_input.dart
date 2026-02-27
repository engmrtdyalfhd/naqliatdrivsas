import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colory.dart';
import '../../manager/auth_cubit.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({super.key});

  @override
  State<OtpInput> createState() => _OtpInputState();

  static final _defaultPinTheme = PinTheme(
    width: 48,
    height: 48,
    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    decoration: BoxDecoration(
      color: Colory.lightBg,
      borderRadius: BorderRadius.circular(16),
    ),
  );

  static final _focusedPinTheme = _defaultPinTheme.copyDecorationWith(
    border: Border.all(color: Colors.blue.shade100),
  );

  static final _submittedPinTheme = _defaultPinTheme.copyDecorationWith(
    color: Colory.lightBg,
  );
}

class _OtpInputState extends State<OtpInput> {
  String msg = "";
  late final TextEditingController _controller;

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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        onChanged: (val) {
          context.read<AuthCubit>().smsCode = val;
        },
        length: 6,
        autofocus: true,
        controller: _controller,
        // validator: (val) {
        //   if (val == null) {
        //     return "Required";
        //   } else {
        //     return msg;
        //   }
        // },
        autofillHints: const [],
        // scrollPadding: EdgeInsets.all(16),
        // errorBuilder: (errorText, pin) {
        //   return Padding(padding: EdgeInsets.only(top: 4), child: Text(msg));
        // },
        onTapOutside: (val) => FocusManager.instance.primaryFocus!.unfocus(),
        onCompleted: (pin) async {
          // _controller.text = "";
          // setState(() {});
        },
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        defaultPinTheme: OtpInput._defaultPinTheme,
        focusedPinTheme: OtpInput._focusedPinTheme,
        submittedPinTheme: OtpInput._submittedPinTheme,
      ),
    );
  }
}
