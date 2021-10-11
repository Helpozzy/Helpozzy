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

  Future launchInstagram() async {
    String url = 'https://www.instagram.com';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch Map $url';
    }
  }

  Future launchWhatsapp() async {
    String url = 'https://wa.me/?text=YourTextHere';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch Map $url';
    }
  }

  Future launchTwitter() async {
    String url = '';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch Map $url';
    }
  }

  Future launchSnapchat() async {
    String url = '';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch Map $url';
    }
  }
}
