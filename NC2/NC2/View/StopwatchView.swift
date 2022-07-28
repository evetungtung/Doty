//
//  StopwatchView.swift
//  NC2
//
//  Created by Evelin Evelin on 21/07/22.
//

import SwiftUI
import UserNotifications

struct StopwatchView: View {
    @ObservedObject var manager: StopwatchManager = StopwatchManager()
    var timerPub = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    @State var isPause = false
    @State var isActive = false
    
    @State var textClr = Color.blue
    @State var textBtn = "Start"


    var body: some View {
        VStack {
            Text(String(format: "%.00f:%.00f", manager.minuteElapsed, manager.secondElapsed))
            
            Button {
                withAnimation(.spring()) {
                    isActive.toggle()
                    if(isActive) {
                        textBtn = "Reset"
                        textClr = Color.red
                        manager.start()
                    }
                    else{
                        textBtn = "Start"
                        textClr = Color.blue
                        manager.stop()
                    }
                }
            } label: {
                Text(textBtn)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .background(textClr)
                    .cornerRadius(10)
            }

//
//            if(isPause){
//                withAnimation {
//                    Button {
//                        isPause = false
//                        textBtn = "Start"
//                    } label: {
//                        Text(textBtn)
//                            .foregroundColor(.white)
//                            .font(.title)
//                            .padding()
//                            .background(Color.red)
//                            .cornerRadius(10)
//                    }
//                    .onReceive(timerPub) { timer in
//                        DispatchQueue.main.async {
//                            manager.secondPub += 1
//                            if(manager.secondPub) == 60 {
//                                manager.minutePub += 1
//                                manager.secondPub = 0
//                            }
//                        }
//                    }
//                }
//            }
//            else{
//                withAnimation {
//                    Button {
//                        isPause = true
//                        timerPub.upstream.connect().cancel()
//                        manager.secondPub = 0
//                        manager.minutePub = 0
//                        textBtn = "Reset"
//                    } label: {
//                            Text(textBtn)
//                                .foregroundColor(.white)
//                                .font(.title)
//                                .padding()
//                                .background(Color.blue)
//                                .cornerRadius(10)
//                        }
//                    }
//                }
//
//
            }
        }
        
    }

class StopwatchManager: ObservableObject{
    @Published var secondElapsed = 0.0
    @Published var minuteElapsed = 0.0
    @Published var isActive = false
    
    var timer = Timer()
    
    @Published var secondPub = 0.0
    @Published var minutePub = 0.0
    
    
    func start() {
        isActive = true
        
        DispatchQueue.main.async {
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                
                self.secondElapsed += 1
                
                if(self.secondElapsed == 60) {
                    self.minuteElapsed += 1
                    self.secondElapsed = 0
                }
            }
        }
        
    }
    
    func stop(){
        isActive = false
        secondElapsed = 0.0
        minuteElapsed = 0.0
        timer.invalidate()
    }
    
}


struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView()
    }
}
