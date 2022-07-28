//
//  TimerView.swift
//  NC2
//
//  Created by Evelin Evelin on 20/07/22.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timerViewModel = TimerViewModel()
    
    @State private var isStarted = false
    @State private var buttonInfo = "Start"
    @State private var minutes = "10"
    @State private var selectedDuration = 0
    @State private var textInfo = "Set the timer to track your activity time"
    @State private var barProgress = 0.0
    
    @FocusState var isInputActive: Bool
    
    
    var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ScrollView{
            VStack{
                Text(textInfo)
                    .font(.headline)
                    .padding()
                
                HStack{
                    Spacer()
                    TextField("Set Your Minutes", text: $minutes)
                        .padding()
                        .frame(width: 100, height: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                    //                    .keyboardType(.numberPad)
                        .focused($isInputActive)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done"){
                                    isInputActive = false
                                }
                                .foregroundColor(Color.blue)
                            }
                        }
                        .onSubmit {
                            if(minutes.isEmpty){
                                minutes = "1"
                            }
                        }
                    Text("Minutes")
                    Spacer()
                }
                
                //Circle
                ZStack {
                    //                  Placeholder ring
                    Circle()
                        .stroke(lineWidth: 20)
                        .foregroundColor(.gray)
                        .opacity(0.1)
                    
                    //                  Top layer ring
                    
                    Circle()
                        .trim(from: 0.0, to: timerViewModel.progress)
                        .stroke(style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round,
                            lineJoin: .round
                        )
                        )
                        .foregroundColor(.newPink)
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.easeInOut(duration: 1), value: timerViewModel.progress)
                    
                    Text("\(timerViewModel.durationTime)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                }
                .frame(width: 250, height: 250)
                .padding()
                .onReceive(timer) { _ in
                    timerViewModel.updateCountDown()
                }
                
                
                //            Button to Start and Give Up
                Button {
                    withAnimation(.spring()) {
                        isStarted.toggle()
                    }
                    if (isStarted) {
                        timerViewModel.durationLeft = Double(minutes) ?? 10
                        timerViewModel.start(durationLeft: timerViewModel.durationLeft)
                        buttonInfo = "Give Up"
                        textInfo = "You can do it!"
                    }
                    else {
                        timerViewModel.giveUp()
                        buttonInfo = "Start"
                        textInfo = "Set the timer to track your activity time"
                    }
                } label: {
                    Text("\(buttonInfo)")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.newYellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                Divider()
                    .padding()
                
                VStack(alignment: .center){
                    Text("Today Total Focus \(String(timerViewModel.sumTime)) minutes")
                        .padding()
                        .font(.system(.headline))
                    ForEach(timerViewModel.timerData.sorted(by: { data1, data2 in
                        String(data1.dateTimer!) > String(data2.dateTimer!)
                    }), id: \.self){
                        data in
                        Text("\(data.dateTimer ?? "Unknown") - \(String(data.minute)) minutes")
                            .padding()
                    }
                }
                .onAppear {
                    timerViewModel.populateData()
                    timerViewModel.showSum()
                }
            }
        }
    }
}

//struct TimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerView(coreDM: CoreDataManager())
//            .previewInterfaceOrientation(.portrait)
//    }
//}
