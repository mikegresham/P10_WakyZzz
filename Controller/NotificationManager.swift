//
//  NotificationManager.swift
//  WakyZzz
//
//  Created by Michael Gresham on 23/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    let url:NSURL = Bundle.main.url(forResource: "sound", withExtension: "mp3")! as NSURL

    
    private init() {
        setAlarmActions()
    }
    
    func scheduleAlarm(for alarm: Alarm) {
        //Function to schedule alarm
        let identifier = alarm.id.uuidString //use alarm ID to keep track of alarms
        let notificationCenter = UNUserNotificationCenter.current()
        
        //Set time zone to current
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current

        // remove previously scheduled notifications
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])

        // create content
        let content = UNMutableNotificationContent()
        content.title = "WakyZzz"
        content.body = "Alarm!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: url.lastPathComponent!))
        content.categoryIdentifier = "ALARM_ACTIONS"
                  
        // create trigger for 8am
        let date = alarm.alarmDate
        let comps = calendar.dateComponents([.day, .hour, .minute, .second], from: date!)
               
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
                  
        // create request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
                  
        // schedule notification
        notificationCenter.add(request, withCompletionHandler:nil)
    }
    
    private func setAlarmActions() {
        // Define the custom actions.
        let stopAction = UNNotificationAction(identifier: "STOP_ACTION",
              title: "Stop",
              options: UNNotificationActionOptions(rawValue: 0))
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
              title: "Snooze",
              options: UNNotificationActionOptions(rawValue: 0))
        // Define the notification type
        let alarmCategory =
              UNNotificationCategory(identifier: "ALARM_ACTIONS",
              actions: [stopAction, snoozeAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([alarmCategory])
    }
    
    func removeAlarm(for id: UUID) {
        let identifier = id.uuidString //use alarm ID to keep track of alarms
        let notificationCenter = UNUserNotificationCenter.current()
        
        //Set time zone to current
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current

        // remove previously scheduled notifications
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
    }
}
