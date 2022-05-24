import 'dart:io';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonUrlLauncher {
  Future launchCall(String contact) async {
    String url = 'tel://$contact';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch Call $url';
    }
  }

  Future launchMap(String address) async {
    final uri =
        Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': '$address'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch Map $uri';
    }
  }

  Future openSystemMap(double lat, double lng) async {
    final uri =
        Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': '$lat,$lng'});
    if (Platform.isAndroid) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch Map $uri';
      }
    } else {
      final String urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
        await launchUrl(Uri.parse(urlAppleMaps));
      } else {
        throw 'Could not launch $urlAppleMaps';
      }
    }
  }

  Future launchApp(
      {required String androidPackageName,
      required String iosUrlScheme,
      required String subject}) async {
    final bool isAvailable = await LaunchApp.isAppInstalled(
        androidPackageName: androidPackageName, iosUrlScheme: iosUrlScheme);
    if (isAvailable) {
      LaunchApp.openApp(
          androidPackageName: androidPackageName, iosUrlScheme: iosUrlScheme);
    } else {
      Share.share(HELPOZZY_TEXT, subject: subject);
    }
  }

  Future shareToOtherApp({required String subject}) async =>
      await Share.share(subject);
}
