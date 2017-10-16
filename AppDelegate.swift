import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        locationManager.delegate = self

        UIApplication.shared.statusBarStyle = .lightContent
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound, .badge]) { (granted, error) in }
        
        return true
    }
}

extension AppDelegate: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        guard region is CLBeaconRegion else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Forgot something?"
        content.body = region.identifier
        content.sound = .default()

        let request = UNNotificationRequest(identifier: "Find Beacons", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
