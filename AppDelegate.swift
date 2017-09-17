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
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }

        return true
    }
}

extension AppDelegate: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("clmanager delegate is called")
        guard region is CLBeaconRegion else {
            print("shout out to Chanel")
            return
        }
        print("made it past da guard")
        
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "YOU FORGOT SOMETHING BITCH"
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "doko", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    /*
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered!")
        guard region is CLBeaconRegion else {
            print("why Chanel")
            return
        }
        
        print("issa beacon region")
    }*/

}
