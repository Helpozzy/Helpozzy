import 'package:local_auth/local_auth.dart';

class Authentication {
  static Future<bool> bometricIsSupported() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool biomatericAvail = await localAuthentication.isDeviceSupported();
    return biomatericAvail;
  }

  static Future<bool> authenticateWithBiometrics() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    bool isAuthenticated = false;

    if (isBiometricSupported && canCheckBiometrics) {
      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
      );
    }

    return isAuthenticated;
  }
}
