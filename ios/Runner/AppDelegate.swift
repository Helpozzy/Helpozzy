import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Add your Google Maps API key
      GMSServices.provideAPIKey("AIzaSyDHlyHquqxv7jZC2ghoWpy_1AdZEtYqrdw")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
