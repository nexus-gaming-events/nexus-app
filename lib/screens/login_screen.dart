import 'package:flutter/material.dart';
import 'package:nexus_app/data_manager.dart';
import 'package:nexus_app/main.dart';
import 'package:nexus_app/services/discord_auth_service.dart';
import 'package:nexus_app/services/google_auth_service.dart';
import 'package:nexus_app/services/secure_storage_service.dart';
import 'package:nexus_app/services/web_interface_service.dart';
import '../constants.dart';
import '../widgets/galaxy_background.dart';
import 'home_screen.dart';

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

    if (result != null && result.accessToken != null) {
      SecureStorageService().saveDiscordToken(result.accessToken!);

      final loginResponse = await WebInterfaceService.loginWithProvider(result.accessToken!, 'discord');
      SecureStorageService().saveNexusToken(loginResponse.token);
      await DataManager.initialize();
      
      final me = await WebInterfaceService.fetchMe();

      debugPrint('Logged in as: ${me.username}');
      debugPrint('Email: ${me.email}');
      debugPrint('Photo URL: ${me.avatarUrl}');
      debugPrint('Discord Access Token: ${result.accessToken}');
      debugPrint('Nexus Access Token: ${loginResponse.token}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome, ${me.username}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home screen after successful login
      NexusAppState.instance!.updateState('Home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed'),
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

      SecureStorageService().saveGoogleAccessToken(accessToken);
      SecureStorageService().saveGoogleIdToken(idToken);

      final loginResponse = await WebInterfaceService.loginWithProvider(idToken, 'google');
      SecureStorageService().saveNexusToken(loginResponse.token);
      await DataManager.initialize();

      final me = await WebInterfaceService.fetchMe();

      debugPrint('Logged in as: ${me.username}');
      debugPrint('Email: ${me.email}');
      debugPrint('Photo URL: ${me.avatarUrl}');
      debugPrint('Google ID Token: $idToken');
      debugPrint('Google Access Token: $accessToken');
      debugPrint('Nexus Access Token: ${loginResponse.token}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome, ${user['name']}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home screen after successful login
      NexusAppState.instance!.updateState('Home');
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
    return GalaxyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingLarge(context) + 8),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Title
              Image.asset(
                'assets/icons/Nexus_logo.png',
                height: AppConstants.iconSizeLarge(context)*3,
                ),
              //SizedBox(height: AppConstants.paddingMedium(context)),
              Text(
                'Explore a galaxy of connections',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLargeResponsive(context)*1.2,
                  color: AppConstants.textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
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
                          icon: Icon(Icons.login, size: AppConstants.iconSizeSmall(context)),
                          label: Text(
                            'Login with Discord',
                            style: TextStyle(fontSize: AppConstants.fontSizeMediumResponsive(context)),
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
                          icon: Icon(Icons.login, size: AppConstants.iconSizeSmall(context)),
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
    ),
    );
  }
}
