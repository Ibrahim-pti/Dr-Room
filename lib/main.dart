import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'core/providers/order_provider.dart';
import 'core/providers/checkout_provider.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/otp_screen.dart';
import 'features/home/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const DrRoomApp());
}

class DrRoomApp extends StatelessWidget {
  const DrRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeProvider().themeModeNotifier,
        builder: (context, themeMode, child) {
          return MaterialApp(
            title: 'DrRoom',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            locale: const Locale('ckb'),
            home: const _AppFlow(),
          );
        },
      ),
    );
  }
}

/// Manages the app flow: Splash → Onboarding → Login ↔ Register → Home
class _AppFlow extends StatefulWidget {
  const _AppFlow();

  @override
  State<_AppFlow> createState() => _AppFlowState();
}

class _AppFlowState extends State<_AppFlow> {
  _FlowState _state = _FlowState.splash;
  String _phoneNumber = '';

  void _goTo(_FlowState state) {
    setState(() => _state = state);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    switch (_state) {
      case _FlowState.splash:
        return SplashScreen(
          key: const ValueKey('splash'),
          onFinished: () => _goTo(_FlowState.onboarding),
        );

      case _FlowState.onboarding:
        return OnboardingScreen(
          key: const ValueKey('onboarding'),
          onFinished: () => _goTo(_FlowState.login),
        );

      case _FlowState.login:
        return LoginScreen(
          key: const ValueKey('login'),
          onLogin: () => _goTo(_FlowState.home),
          onSignUp: () => _goTo(_FlowState.register),
        );
        
      case _FlowState.register:
        return RegisterScreen(
          key: const ValueKey('register'),
          onRegister: () => _goTo(_FlowState.home),
          onLogin: () => _goTo(_FlowState.login),
        );

      case _FlowState.otp:
        // Keep OTP state in case it's needed later for verification flow
        return OtpScreen(
          key: const ValueKey('otp'),
          phoneNumber: _phoneNumber,
          onVerified: () => _goTo(_FlowState.home),
          onBack: () => _goTo(_FlowState.login),
        );

      case _FlowState.home:
        return const MainShell(
          key: ValueKey('home'),
        );
    }
  }
}

enum _FlowState {
  splash,
  onboarding,
  login,
  register,
  otp,
  home,
}
