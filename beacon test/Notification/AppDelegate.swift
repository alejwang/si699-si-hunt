//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit
import UserNotifications

import EstimoteProximitySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var proximityObserver: ProximityObserver!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("notifications permission granted = \(granted), error = \(error?.localizedDescription ?? "(none)")")
        }


        let estimoteCloudCredentials = CloudCredentials(appID: "alejwang-umich-edu-s-notif-hs4", appToken: "ca63191da08c32c24168e81cb3ff51bf")

        proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
            print("ProximityObserver error: \(error)")
        })

        let zone = ProximityZone(tag: "alejwang-umich-edu-s-notif-hs4", range: ProximityRange.near)
        zone.onEnter = { context in
            let content = UNMutableNotificationContent()
            content.title = "Hello"
            content.body = "You're near your tag"
            content.sound = UNNotificationSound.default()
            let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
            notificationCenter.add(request, withCompletionHandler: nil)
        }
        zone.onExit = { context in
            let content = UNMutableNotificationContent()
            content.title = "Bye bye"
            content.body = "You've left the proximity of your tag"
            content.sound = UNNotificationSound.default()
            let request = UNNotificationRequest(identifier: "exit", content: content, trigger: nil)
            notificationCenter.add(request, withCompletionHandler: nil)
        }

        proximityObserver.startObserving([zone])

        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // Needs to be implemented to receive notifications both in foreground and background
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound])
    }
}
