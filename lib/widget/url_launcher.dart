import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonUrlLauncher {
  Future launchCall(String contact) async {
    String url = 'tel://$contact';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Call $url';
    }
  }

  Future launchMap(String address) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Map $url';
    }
  }

  Future openSystemMap(double lat, double lng) async {
    String url = '';
    String urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      url = 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(urlAppleMaps)) {
      await launch(urlAppleMaps);
    } else {
      throw 'Could not launch $url';
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

  Future shareToOtherApp({required String subject}) async {
    Share.share(HELPOZZY_TEXT, subject: subject);
  }
}
