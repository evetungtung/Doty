//
//  TimerManager.swift
//  NC2
//
//  Created by Evelin Evelin on 20/07/22.
//

import Foundation
import SwiftUI
import CoreData

class TimerViewModel: ObservableObject {
    
    private var initialTime = 0
    private var endDate = Date()
    
    @Published private(set) var isActive = false
    @Published private(set) var durationTime: String = "Let's Focus"
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0
    @Published private(set) var timerData: [DataTimer] = [DataTimer]()
    @Published private(set) var needLoad: Bool = false
    
    private var durationSetSecond: Double = 1.0
    
    @Published var durationLeft: Double = 1.0 {
        didSet {
            self.durationTime = "\(Int(durationLeft)):00"
        }
    }
    
    func populateData(){
        timerData = CoreDataManager.shared.showDataTimer()
        showSum()
    }
    
    func start(durationLeft: Double) {
        self.initialTime = Int(durationLeft)
        self.endDate = Date()
        self.isActive = true
        self.durationSetSecond = durationLeft*60
        
        //        Nambahin menit dari timer ke jam sekarang
        self.endDate = Calendar.current.date(byAdding: .minute, value: Int(durationLeft), to: endDate)!
        makingNotification(durationSetSecond: self.durationSetSecond)
    }
    
    func giveUp(){
        self.durationLeft = Double(initialTime)
        self.isActive = false
        self.durationTime = "\(Int(durationLeft)):00"
        NotifManager.shared.removeNotifByTime()
    }
    
    func updateCountDown(){
        guard isActive else {
            elapsedTime = 0
            progress = 0
            return
        }
        
        //        Ngambil date sekarang
        let now = Date()
        
        //        Ngitung perbedaan waktu dari jam yang ditentukan ke jam sekarang. Misal end nya maunya 08:44:35, terus tadi sempet out dari appnya, jadi Date now adalah 08:44:20. Kurangin aja nanti dapet diff (supaya bisa track background juga)
        let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
        
        //        Kalo misalkan udah ga ada perbedaan dari waktu Now dengan EndDate, dia berarti udah kelar
        if diff <= 0 {
            self.isActive = false
            self.durationTime = "Let's Focus"
            CoreDataManager.shared.saveTimerDone(minute: (durationSetSecond/60), date: now)
            populateData()
            
            needLoad = true
            return
        }
        
        //        Ini untuk dapet perkembangan diffnya tapi settingnya kek 00:00:00
        let date = Date(timeIntervalSince1970: diff)
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        self.elapsedTime += 1
        if(self.isActive){
            self.progress = (self.elapsedTime/self.durationSetSecond*100)/100
        }
        
        self.durationLeft = Double(minutes)
        self.durationTime = String(format: "%d:%02d", minutes, seconds)
        print()
    }
    
    func makingNotification(durationSetSecond: Double){
        NotifManager.shared.content.title = "Time's Up"
        NotifManager.shared.content.subtitle = "Congrats on finishing your focus timer"
        NotifManager.shared.content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm.wav"))
        NotifManager.shared.setNotifByTime(durationSetSecond: durationSetSecond)
        
    }
    
    @Published private(set) var sumTime: Int = 0
    
    func showSum(){
        sumTime = CoreDataManager.shared.showDataToday(date: Date.now)
        print("SHOW SUM \(sumTime)")
    }
    
}
