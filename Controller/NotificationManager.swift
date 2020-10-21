//
//  NotificationManager.swift
//  WakyZzz
//
//  Created by Michael Gresham on 23/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import Foundation
import UserNotifications
import AVFoundation

class NotificationManager {
    
    let actsOfKindness = ["watering the plants", "messaging a friend to ask how they are doing", "connecting with a family member by expressing a kind thought", "buying a friend a coffee", "sending an encouraging email", "complimenting a coworker"]
    
    var userNotificationCenter = UNUserNotificationCenter.current()
    static let shared = NotificationManager()
    
    var trigger: UNCalendarNotificationTrigger?

    private init() {
        setAlarmActions()
    }
    
    func scheduleAlarms(alarms: [Alarm]) {
        let enabledAlarms = alarms.filter( {$0.enabled == true})
        for alarm in enabledAlarms {
            scheduleAlarm(for: alarm)
        }
    }
    
    func scheduleAlarm(for alarm: Alarm) {
        var identifier = alarm.id.uuidString //use alarm ID to keep track of alarms

        //Set time zone to current
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current

        // remove previously scheduled notifications
        removeAlarms(for: alarm.id)
        // create content
        let content = createContent(for: alarm)
                  
        if alarm.repeatDays.allSatisfy({$0 == false }) {
            let components = calendar.dateComponents([.hour, .minute, .month, .year, .day], from: alarm.alarmDate!)
            self.trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
             scheduleNotification(id: identifier, content: content, trigger: trigger!)
        } else {
            for day in 0..<alarm.repeatDays.count {
                if alarm.repeatDays[day] == true {
                    identifier = "\(alarm.id.uuidString)_weekday\(day + 1)"
                    
                    var components = calendar.dateComponents([.hour, .minute, .weekday], from: alarm.alarmDate! as Date)
                    components.weekday = day + 1
                    
                    self.trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    scheduleNotification(id: identifier, content: content, trigger: trigger!)
                }
            }
        }
    }
    
    func scheduleNotification(id: String, content: UNNotificationContent, trigger: UNNotificationTrigger){
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        // schedule notification
        userNotificationCenter.add(request, withCompletionHandler:nil)
    }
    
    private func setAlarmActions() {
        // Define the custom actions.
        let stopAction = UNNotificationAction(identifier: "STOP_ACTION",
              title: "Stop",
              options: UNNotificationActionOptions(rawValue: 0))
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
              title: "Snooze",
              options: UNNotificationActionOptions(rawValue: 0))
        let completeAction = UNNotificationAction(identifier: "COMPLETE_ACTION",
              title: "Mark As Completed",
              options: UNNotificationActionOptions(rawValue: 0))
        let laterAction = UNNotificationAction(identifier: "LATER_ACTION",
              title: "Remind Me Later",
              options: UNNotificationActionOptions(rawValue: 0))
        // Define the notification type
        let snoozeCategory =
              UNNotificationCategory(identifier: "SNOOZE_ACTIONS",
              actions: [stopAction, snoozeAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        let evilCategory =
              UNNotificationCategory(identifier: "EVIL_ACTIONS",
              actions: [completeAction, laterAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        // Register the notification type.
        userNotificationCenter.setNotificationCategories([snoozeCategory, evilCategory])
    }
    
    func removeAlarms(for id: UUID) {
        let identifier = id.uuidString //use alarm ID to keep track of alarms
        
        //Set time zone to current
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        var identifiers = [String]()
        identifiers.append(identifier)
        
        for day in 1...7 { identifiers.append("\(identifier)_weekday\(day)") }

        // remove previously scheduled notifications
        userNotificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
    }

    func snoozeAlarm(alarm: Alarm) {
        let identifier = "\(alarm.id)"
        let notificationCenter = UNUserNotificationCenter.current()
       
        // remove previously scheduled notifications
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
       
        // create content
        let content = createContent(for: alarm)
  
        // create trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        scheduleNotification(id: identifier, content: content, trigger: trigger)
    }
    
    func createContent(for alarm: Alarm) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()

        switch alarm.snoozeCounter {
        case 0:
            content.title = alarm.caption
            content.body = "Time to wake up!"
            content.userInfo = ["alarmID": "\(alarm.id)"]
            content.categoryIdentifier = "SNOOZE_ACTIONS"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm_low.mp3"))
        case 1:
            content.title = alarm.caption
            content.body = "This is your second alarm sleepyhead!"
            content.userInfo = ["alarmID": "\(alarm.id)"]
            content.categoryIdentifier = "SNOOZE_ACTIONS"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm_high.mp3"))
        default:
            content.title = "\(alarm.caption) You snoozed too many times!"
            content.body = "Redeem yourself by \(actsOfKindness.randomElement()!)"
            content.userInfo = ["alarmID": "\(alarm.id)", "actOfKindness": content.body]
            content.categoryIdentifier = "EVIL_ACTIONS"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm_evil.mp3"))
        }
        
        return content
    }
    
    func scheduleReminder(alarm: Alarm, actOfKindness: String){
        let identifier = "\(alarm.id)"
        let notificationCenter = UNUserNotificationCenter.current()
       
        // remove previously scheduled notifications
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
       
        // create content
        let content = UNMutableNotificationContent()
        content.title = "WakyZzz"
        content.body = actOfKindness
        content.userInfo = ["alarmID": identifier, "actOfKindness": content.body]
        content.categoryIdentifier = "EVIL_ACTIONS"
  
        // create trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        scheduleNotification(id: identifier, content: content, trigger: trigger)
    }
}

