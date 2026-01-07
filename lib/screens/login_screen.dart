import 'package:flutter/material.dart';
import 'package:nexus_app/services/discord_auth_service.dart';
import 'package:nexus_app/services/google_auth_service.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _handleDiscordLogin() async {
    setState(() => _isLoading = true);

    final result = await DiscordAuthService.loginWithDiscord();

    if (!mounted) return;

    if (result['success']) {
      final user = result['user'];
      final accessToken = result['accessToken'];

      // TODO: Save the token securely (use flutter_secure_storage)
      // TODO: Update your app state with the logged-in user

      debugPrint('Logged in as: ${user['username']}#${user['discriminator']}');
      debugPrint('User ID: ${user['id']}');
      debugPrint('Email: ${user['email']}');
      debugPrint('Access Token: $accessToken');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome, ${user['username']}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home screen after successful login
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${result['error']}'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    final result = await GoogleAuthService.googleLogin();

    if (!mounted) return;

    if (result['success']) {
      final user = result['user'];
      final idToken = result['idToken'];
      final accessToken = result['accessToken'];

      // TODO: Save the token securely (use flutter_secure_storage)
      // TODO: Update your app state with the logged-in user

      debugPrint('Logged in as: ${user['name']}');
      debugPrint('Email: ${user['email']}');
      debugPrint('Photo URL: ${user['photoUrl']}');
      debugPrint('ID Token: $idToken');
      debugPrint('Access Token: $accessToken');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome, ${user['name']}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home screen after successful login
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      debugPrint('Login failed: ${result['error']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${result['error']}'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryBackgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.paddingLarge(context) + 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Title
              Text(
                'Nexus',
                style: TextStyle(
                  fontSize: AppConstants.screenHeight(
                    context,
                    0.06,
                  ).clamp(40.0, 48.0),
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              SizedBox(height: AppConstants.paddingLarge(context)),
              Text(
                'Connect with your community',
                style: TextStyle(
                  fontSize: 16,
                  color: AppConstants.textColor.withOpacity(0.7),
                ),
              ),
              SizedBox(
                height: AppConstants.screenHeight(
                  context,
                  0.08,
                ).clamp(56.0, 64.0),
              ),

              // Discord Login Button
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _handleDiscordLogin,
                          icon: const Icon(Icons.login, size: 24),
                          label: const Text(
                            'Login with Discord',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF5865F2,
                            ), // Discord blue
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  AppConstants.paddingLarge(context) * 2,
                              vertical: AppConstants.paddingLarge(context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusSmall(context),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppConstants.paddingLarge(context)),
                        ElevatedButton.icon(
                          onPressed: _handleGoogleLogin,
                          icon: const Icon(Icons.login, size: 24),
                          label: Text(
                            'Login with Google',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMediumResponsive(
                                context,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF4285F4,
                            ), // Google blue
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  AppConstants.paddingLarge(context) * 2,
                              vertical: AppConstants.paddingLarge(context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusSmall(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
