//
//  NotificationCenter.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationFactory {
    
    static func createGeofencingNotification() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "Unavailable area"
        content.body = "You are leaving KMITL Bike permitted area. Please go back"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = "Geofencing Notification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        return request
    }
    
    static func createLastMinuteReturnWarning(lastMinute: Int) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "You got " + String(lastMinute) + " minutes"
        content.body = "Please return the bike ASAP"
        let requestIdentifier = "Warning Notification"
        var dateComponents = DateComponents()
        
        dateComponents.minute = 60 - lastMinute
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: notificationTrigger)
        return request
    }
}
