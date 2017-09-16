import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent

        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }

        return true
    }
}

extension AppDelegate: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        guard region is CLBeaconRegion else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "body"
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "doko", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
