//
//  NotifManager.swift
//  NC2
//
//  Created by Evelin Evelin on 27/07/22.
//

import Foundation
import UserNotifications

class NotifManager {
    static let shared: NotifManager = NotifManager()
    let notificationCenter = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var dataID: String = String()
    
    public func getAuth(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func setNotifByDate(deadline: Date){
        let dateComp = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        let request = UNNotificationRequest(
            identifier: dataID,
            content: content,
            trigger: trigger
        )
        notificationCenter.add(request)
    }
    
    public func deleteNotif(dataID: String){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [dataID])
    }
    
    public func setNotifByTime(durationSetSecond: Double){
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: durationSetSecond, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerData", content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    public func removeNotifByTime(){
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: ["TimerData"])
    }
}
