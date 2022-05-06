import 'package:local_auth/local_auth.dart';

class Authentication {
  final LocalAuthentication localAuthentication = LocalAuthentication();
  Future<bool> bometricIsSupported() async {
    final bool biomatericAvail = await localAuthentication.isDeviceSupported();
    return biomatericAvail;
  }

  Future<bool> authenticateWithBiometrics() async {
    final bool isBiometricSupported =
        await localAuthentication.isDeviceSupported();
    final bool canCheckBiometrics =
        await localAuthentication.canCheckBiometrics;
    late bool isAuthenticated = false;

    if (isBiometricSupported && canCheckBiometrics) {
      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        options: AuthenticationOptions(
          useErrorDialogs: true,
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    }
    return isAuthenticated;
  }
}
