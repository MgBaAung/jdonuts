import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jdonutscodetest/core/result.dart';
import 'package:jdonutscodetest/global/app_theme.dart';
import 'package:jdonutscodetest/global/custom_button.dart';
import 'package:jdonutscodetest/global/extension/num_extension.dart';
import 'package:jdonutscodetest/global/extension/text_extension.dart';

import '../domain/auth_validators.dart';
import 'state_management/auth_flow_cubit.dart';
import '../../app/app_route_args.dart';

import 'package:go_router/go_router.dart';

import '../../shared/motion.dart';
import '../../shared/presentation/widgets.dart';

InputDecoration _authInput(
  BuildContext context,
  String hint, {
  String? label,
  String? counterText,
}) => InputDecoration(
  hintText: hint,
  labelText: label,
  counterText: counterText,
  hintStyle: context.light(fSize: 12, color: const Color(0xff8d8790)),
  labelStyle: context.light(fSize: 12, color: const Color(0xff8d8790)),
  // style: context.regular(fSize: 14),
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: const BorderSide(color: Color(0xffef5c9b), width: 1.4),
  ),
);

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _placeholder(BuildContext context, String feature) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (_) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '$feature sign-in is a demo placeholder.',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white, Colors.transparent],
                  stops: [0.0, 0.75, 1.0], // Fades out smoothly near the bottom
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.53,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/donutbg.jpeg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, _, _) =>
                      const ColoredBox(color: Color(0xFFFFF0F5)),
                ),
              ),
            ),

            // 2. Bottom Section: Text, buttons, and links
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              color: Colors.pink.shade100,
              child: Column(
                children: [
                  Text(
                    'Round food for\nevery mood',
                    textAlign: TextAlign.center,
                    style: context.bold(fSize: 22),
                  ),
                  18.height,
                  CustomElevatedButton(
                    btnLabel: "LET'S GET STARTED",
                    onPressedFun: () => context.push('/phone', extra: true),
                  ),
                  6.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ', style: context.light()),
                      GestureDetector(
                        onTap: () => context.push('/phone', extra: false),
                        child: Text('Log In', style: context.light()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(
                        context,
                        'Google',
                        const FaIcon(
                          FontAwesomeIcons.google,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 20),
                      _socialButton(
                        context,
                        'Apple',
                        const FaIcon(
                          FontAwesomeIcons.apple,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 20),
                      _socialButton(
                        context,
                        'Facebook',
                        const Icon(
                          Icons.facebook,
                          size: 17,
                          color: Color(0xFF1877F2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'By continuing, you acknowledge that you have read and\nagree to our Terms of Use and Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 7,
                        color: Color(0xFF85818A),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(BuildContext context, String label, Widget icon) =>
      InkResponse(
        onTap: () => _placeholder(context, label),
        radius: 22,
        child: SizedBox(width: 22, height: 22, child: Center(child: icon)),
      );
}

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key, required this.registration});
  final bool registration;
  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final controller = TextEditingController(text: "09254135592");
  final focus = FocusNode();
  String? error;
  bool blurred = false;
  bool get valid => AuthValidators.isValidPhone(controller.text);

  @override
  void initState() {
    super.initState();
    focus.addListener(() {
      if (!focus.hasFocus) {
        setState(() {
          blurred = true;
          error = valid ? null : 'Enter a valid Myanmar phone number';
        });
      }
    });
  }

  @override
  void dispose() {
    focus.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthStepScaffold(
    step: 1,
    title: 'Enter your phone\nnumber',
    subtitle: 'We’ll send you a one-time verification code.',
    button: CustomElevatedButton(
      btnLabel: "CONTINUE",
      onPressedFun: valid
          ? () {
              final phone = AuthValidators.normalizePhone(controller.text);
              context.push(
                '/otp',
                extra: OtpRouteArgs(
                  phone: phone,
                  registration: widget.registration,
                ),
              );
            }
          : () {},
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text('+95', style: context.semibold()),
            ),
            10.width,
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focus,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  focus.unfocus();
                  setState(() {
                    blurred = true;
                    error = valid ? null : 'Enter a valid Myanmar phone number';
                  });
                },
                onChanged: (_) => setState(() {
                  error = null;
                }),
                decoration: _authInput(context, '09254135592'),
              ),
            ),
          ],
        ),
        if (error != null && blurred)
          Text(error!, style: context.regular(fSize: 12, color: Colors.red)),
      ],
    ),
  );
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone, this.registration = false});
  final String phone;
  final bool registration;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  final fields = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());
  late final AnimationController shake;
  int attempts = 0, seconds = 300;
  bool locked = false, unknownLogin = false, busy = false;
  Timer? timer;
  String? error;
  String get code => fields.map((field) => field.text).join();
  @override
  void initState() {
    super.initState();
    shake = AnimationController(
      vsync: this,
      duration: MotionDurations.otpShake,
    );
    if (widget.phone == demoOtpPhone) {
      for (var i = 0; i < demoOtp.length; i++) {
        fields[i].text = demoOtp[i];
      }
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && seconds > 0) setState(() => seconds--);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    shake.dispose();
    for (final field in fields) {
      field.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _acceptInput(int index, String value) {
    if (value.length > 1) {
      final digits = value
          .replaceAll(RegExp(r'\D'), '')
          .substring(
            0,
            value.replaceAll(RegExp(r'\D'), '').length.clamp(0, 6).toInt(),
          );
      for (var i = 0; i < 6; i++) {
        fields[i].text = i < digits.length ? digits[i] : '';
      }
      focusNodes[digits.isEmpty ? 0 : digits.length - 1].requestFocus();
      setState(() => error = null);
      return;
    }
    if (value.isNotEmpty && index < 5) focusNodes[index + 1].requestFocus();
    if (value.isEmpty && index > 0) focusNodes[index - 1].requestFocus();
    setState(() => error = null);
  }

  Future<void> _verify() async {
    if (busy || locked) return;
    if (code.length != 6 || !AuthValidators.isValidOtp(code)) {
      if (code.length == 6) {
        attempts++;
        shake.forward(from: 0);
        for (final field in fields) {
          field.clear();
        }
        focusNodes.first.requestFocus();
      }
      setState(() {
        error = attempts >= 3
            ? 'Too many attempts. Resend a code to continue.'
            : 'Incorrect code. ${3 - attempts} attempts remaining.';
        locked = attempts >= 3;
      });
      return;
    }
    setState(() => busy = true);
    try {
      final result = await context.read<AuthFlowCubit>().loginIfRegistered(
        widget.phone,
      );
      if (!mounted) return;
      if (result case Failed<bool>(:final failure)) {
        setState(() => error = failure.message);
        return;
      }
      final existing = (result as Success<bool>).value;
      if (existing) {
        context.go('/home');
      } else if (widget.registration) {
        context.push('/name', extra: widget.phone);
      } else {
        setState(() {
          unknownLogin = true;
          error = 'No account found for this number.';
        });
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _resend() {
    setState(() {
      attempts = 0;
      locked = false;
      unknownLogin = false;
      error = null;
      seconds = 300;
      for (final field in fields) {
        field.clear();
      }
    });
    focusNodes.first.requestFocus();
  }

  @override
  Widget build(BuildContext context) => AuthStepScaffold(
    step: 2,
    title: 'Verify your\nnumber',
    subtitle: widget.phone == demoOtpPhone
        ? 'Demo code $demoOtp sent to ${widget.phone}'
        : 'Enter the 6-digit code sent to ${widget.phone}',
    button: AuthPrimaryButton(
      text: busy ? 'Verifying…' : 'Verify',
      onTap: busy || locked ? null : _verify,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: shake,
          builder: (_, child) => Transform.translate(
            offset: Offset(
              math.sin(shake.value * math.pi * 8) * 8 * (1 - shake.value),
              0,
            ),
            child: child,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (i) => SizedBox(
                width: 50,
                child: TextField(
                  controller: fields[i],
                  focusNode: focusNodes[i],
                  enabled: !locked && !busy,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => _acceptInput(i, value),
                  decoration: _authInput(context, '', counterText: ''),
                ),
              ),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(error!, style: const TextStyle(color: Colors.red)),
          ),
        if (unknownLogin)
          TextButton(
            onPressed: () => context.push('/name', extra: widget.phone),
            child: const Text('Create an account instead'),
          ),
        10.height,

        Center(
          child: TextButton(
            onPressed: seconds == 0 || locked ? _resend : null,
            child: Text(
              seconds == 0 || locked
                  ? 'Resend code'
                  : 'Resend code in ${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
            ),
          ),
        ),
      ],
    ),
  );
}

class NameScreen extends StatefulWidget {
  const NameScreen({super.key, required this.phone});
  final String phone;
  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final first = TextEditingController(), last = TextEditingController();
  String? error;
  @override
  void dispose() {
    first.dispose();
    last.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthStepScaffold(
    step: 3,
    title: 'What’s your\nname?',
    subtitle: '',
    button: AuthPrimaryButton(
      text: 'Continue',
      onTap: () {
        final validation =
            AuthValidators.validateName(first.text, requiredName: true) ??
            AuthValidators.validateName(last.text, requiredName: false);
        if (validation != null) {
          setState(() => error = validation);
          return;
        }
        context.push(
          '/dob',
          extra: RegistrationRouteArgs(
            phone: widget.phone,
            firstName: first.text.trim(),
            lastName: last.text.trim(),
          ),
        );
      },
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: first,
          decoration: _authInput(context, 'First Name'),
        ),
        12.height,
        TextField(
          controller: last,
          decoration: _authInput(context, 'Last Name'),
        ),
        if (error != null)
          Text(error!, style: const TextStyle(color: Colors.red)),
        18.height,
      ],
    ),
  );
}

class BirthDateScreen extends StatefulWidget {
  const BirthDateScreen({
    super.key,
    required this.phone,
    required this.firstName,
    required this.lastName,
  });
  final String phone, firstName, lastName;
  @override
  State<BirthDateScreen> createState() => _BirthDateScreenState();
}

class _BirthDateScreenState extends State<BirthDateScreen> {
  final month = TextEditingController(),
      day = TextEditingController(),
      year = TextEditingController();
  String? error;
  DateTime? _birthDate() {
    try {
      final parsed = DateTime(
        int.parse(year.text),
        int.parse(month.text),
        int.parse(day.text),
      );
      if (parsed.month != int.parse(month.text) ||
          parsed.day != int.parse(day.text)) {
        return null;
      }
      return parsed;
    } catch (_) {
      return null;
    }
  }

  String? _dateError() {
    if (month.text.isEmpty || day.text.isEmpty || year.text.length != 4) {
      return null;
    }
    final value = _birthDate();
    return value == null
        ? 'Enter a valid calendar date'
        : AuthValidators.validateBirthDate(value);
  }

  bool get _canContinue => _dateError() == null && _birthDate() != null;
  @override
  void dispose() {
    month.dispose();
    day.dispose();
    year.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthStepScaffold(
    step: 4,
    title: 'What’s your\ndate of birth?',
    subtitle: '',
    button: BlocBuilder<AuthFlowCubit, AuthFlowState>(
      builder: (context, state) => AuthPrimaryButton(
        text: state.isLoading ? 'Creating account…' : 'Continue',
        onTap: !_canContinue || state.isLoading
            ? null
            : () async {
                final birth = _birthDate()!;
                final validation = AuthValidators.validateBirthDate(birth);
                if (validation != null) {
                  setState(() => error = validation);
                  return;
                }
                final result = await context.read<AuthFlowCubit>().register(
                  phone: widget.phone,
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  birthDate: birth,
                );
                if (!context.mounted) return;
                if (result case Failed<void>(:final failure)) {
                  setState(() => error = failure.message);
                  return;
                }
                context.go('/welcome', extra: widget.phone);
              },
      ),
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            TextField(
              key: const Key('birth-month'),
              controller: month,
              keyboardType: TextInputType.number,
              maxLength: 2,
              onChanged: (_) => setState(() {
                error = _dateError();
              }),
              decoration: _authInput(context, 'Month', counterText: ''),
            ),
            10.height,
            TextField(
              key: const Key('birth-day'),
              controller: day,
              keyboardType: TextInputType.number,
              maxLength: 2,
              onChanged: (_) => setState(() {
                error = _dateError();
              }),
              decoration: _authInput(context, 'Day', counterText: ''),
            ),
            10.height,
            TextField(
              key: const Key('birth-year'),
              controller: year,
              keyboardType: TextInputType.number,
              maxLength: 4,
              onChanged: (_) => setState(() {
                error = _dateError();
              }),
              decoration: _authInput(context, 'Year', counterText: ''),
            ),
          ],
        ),
        if (error != null)
          Text(error!, style: const TextStyle(color: Colors.red)),
        18.height,
      ],
    ),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xfffff3f7),
    body: Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white, Colors.transparent],
              stops: [0.0, 0.75, 1.0], // Fades out smoothly near the bottom
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.infinity,
            child: Image.asset(
              'assets/images/welcome.jpeg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, _, _) =>
                  const ColoredBox(color: Color(0xFFFFF0F5)),
            ),
          ),
        ),

        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00FFFFFF), Color(0xBBFFD7DE)],
                stops: [0.0, 0.5],
              ),
            ),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: 24.allSpacing,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'Welcome to the\nworld of J’Donuts!',
                  textAlign: TextAlign.center,
                  style: context
                      .bold(fSize: 22, color: ink)
                      .copyWith(height: 1.08),
                ),
                8.height,
                Text(
                  'Your next favorite donut is waiting.',
                  textAlign: TextAlign.center,
                  style: context.light(
                    fSize: 12,
                    color: const Color(0xff8d8790),
                  ),
                ),
                30.height,
                AuthPrimaryButton(
                  text: 'LET’S EXPLORE',
                  onTap: () => context.go('/home'),
                ),

                20.height,
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
