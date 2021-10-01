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
}
