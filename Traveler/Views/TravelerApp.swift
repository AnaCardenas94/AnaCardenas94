//
//  TravelerApp.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 13/11/25.
//

import SwiftUI
import SwiftData
import FirebaseCore
import GoogleSignIn
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      if let clientID = FirebaseApp.app()?.options.clientID {
          let config = GIDConfiguration(clientID: clientID)
          GIDSignIn.sharedInstance.configuration = config
      } else {
          fatalError("GoogleService-Info.plist not found or missing clientID")
      }
    return true
  }
}

@main
struct TravelerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WalkthroughView()
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
        .modelContainer(for: [
            User.self,
            Activity.self,
            ExpenseModel.self
        ])
    }
}
