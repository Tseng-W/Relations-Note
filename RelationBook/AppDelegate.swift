//lead
//  AppDelegate.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import UserNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  static let shared = UIApplication.shared.delegate as! AppDelegate

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey(Bundle.valueForString(key: "Google map api key"))
    GMSPlacesClient.provideAPIKey(Bundle.valueForString(key: "Google map api key"))

    IQKeyboardManager.shared.enable = true

    UITabBar.appearance().tintColor = .button

    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.button]
    UINavigationBar.appearance().barTintColor = .background
    UINavigationBar.appearance().tintColor = .button
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().shadowImage = UIImage()

    //    registerForPushNotifications()

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self

      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions) { _, _ in }
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    if let style = UserDefaults.standard.getString(key: .style) {
      if style == "dark" {
        window?.overrideUserInterfaceStyle = .dark
      } else if style == "light" {
        window?.overrideUserInterfaceStyle = .light
      }
    }

    application.registerForRemoteNotifications()

    Messaging.messaging().delegate = self

    #if targetEnvironment(simulator)
    simulator()

    #else
    loginTokenCheck()
    #endif

    return true
  }

  // MARK: UISceneSession Lifecycle
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }

  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      print("Notification settings: \(settings)")

      guard settings.authorizationStatus == .authorized else { return }

      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }

  // MARK: - Push notification

  func registerForPushNotifications() {
    UNUserNotificationCenter.current()
      .requestAuthorization(
        options: [.alert, .sound, .badge]) { [weak self] granted, _ in
        print("Permission granted: \(granted)")

        guard granted else { return }

        self?.getNotificationSettings()
      }
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()

    print("Device Token: \(token)")
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Failed to register: \(error)")
  }

  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "PersonBook")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  // MARK: - Core Data Saving support
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

extension AppDelegate {
  private func simulator() {
    UserDefaults.standard.setValue("wYfB9hMVHXQQ2ZPBdjsCBdalUZe2", forKey: UserDefaults.Keys.uid.rawValue)
    UserDefaults.standard.setValue("mockEmail2", forKey: UserDefaults.Keys.email.rawValue)

    if let mainVC = UIStoryboard.main.instantiateInitialViewController() {
      window?.rootViewController = mainVC
    } else {
      print("Can't initial main tab bar view controller.")
    }
  }

  private func loginTokenCheck() {
    if let user = Auth.auth().currentUser {
      UserDefaults.standard.setValue(user.email, forKey: UserDefaults.Keys.email.rawValue)
      UserDefaults.standard.setValue(user.uid, forKey: UserDefaults.Keys.uid.rawValue)

      if let mainVC = UIStoryboard.main.instantiateInitialViewController() {
        window?.rootViewController = mainVC
      } else {
        print("Can't initial main tab bar view controller.")
      }
    } else {
      if let loginViewController = UIStoryboard.login.instantiateViewController(identifier: "login") as? LoginViewController {
        window?.rootViewController = loginViewController
      } else {
        print("Can't initial main tab bar view controller.")
      }
    }
  }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    let dataDict: [String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

    Messaging.messaging().token { token, error in
      if let error = error {
        print("Error fetching FCM registration token: \(error)")
      } else if let token = token {
        print("FCM registration token: \(token)")
      }
    }
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let userInfo = notification.request.content.userInfo

    print(userInfo)

    completionHandler([[.alert, .sound, .badge]])
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo

    print(userInfo)

    completionHandler()
  }
}
