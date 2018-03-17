//
//  Sheduler.swift
//  Alarm
//
//  Created by Petar Korda on 5/7/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import Foundation
import UserNotifications


class Scheduler {
    
    init() {}
    
    
    func scheduleNotification(alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "WAKE UP"
        
        content.body = "Start your day in the most perfect way with EasyMorning"
        content.badge = 0
        content.sound = UNNotificationSound(named: "alarm-sound1.mp3")
        
        content.userInfo = alarm.propertyDictRepresentation
        
        let actionStart = UNNotificationAction(identifier: "start", title: "START", options: .foreground)
        let actionSnooze = UNNotificationAction(identifier: "snooze", title: "SNOOZE", options: .destructive)
        
        let category = UNNotificationCategory(identifier: "cat", actions: [actionStart, actionSnooze], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        content.categoryIdentifier = "cat"
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alarm.date.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        
    }
    
    
    
    func descheduleNotification(alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        
    }
    
    func rescheduleNotification(alarm: Alarm) {}
    
    
}

