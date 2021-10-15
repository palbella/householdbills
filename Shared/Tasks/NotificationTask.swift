//
//  BackgroundThreadTask.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/1/21.
//

import Foundation
import UserNotifications

class NotificationTask: ObservableObject {

    
    init() {
    
    }
    
    func run(title: String, subtitle: String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
     
    }
}
