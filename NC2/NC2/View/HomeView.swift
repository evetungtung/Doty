//
//  HomeView.swift
//  NC2
//
//  Created by Evelin Evelin on 19/07/22.
//

import Foundation
import SwiftUI
import UserNotifications

struct HomeView: View{    
    @ObservedObject var quadrantVM = QuadrantViewModel()

    var body: some View {
        NavigationView {
            VStack{
                ZStack(alignment: .leading){
                    Rectangle()
                        .fill(Color.newPink)
                    
                    VStack (alignment: .leading, spacing: 10){
                        Text("Hi!")
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                                                    
                        Text("Ready to do your task?")
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                        
                        NavigationLink(destination: AddTaskView().navigationTitle("Add Task").navigationBarTitleDisplayMode(.inline)) {
                            Text("Add Task")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding()
                                .background(
                                    Color.newYellow
                                        .cornerRadius(10)
                                )

                        }
                    }
                    .padding(30)
                }
                .ignoresSafeArea()


                Spacer()
                    VStack{
                        ForEach(quadrantVM.dataQuadrant.sorted(by: {
                            data1, data2 in
                            data1.priority > data2.priority
                        }), id: \.self) {
                            data in
                            NavigationLink(destination: TaskDetailView(quadrant: data)) {
                                Text(data.name ?? "Unknown data name")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(width: 300, height: 100)
                                    .background(
                                        Color.darkPurple
                                            .cornerRadius(10)
                                    )
                            }
                        }
                    }
                Spacer()
            }
            .onAppear {
                quadrantVM.getAllQuadrant()
                quadrantVM.initQuadrantData()
            }

        }
    }
}

struct HomeView_Preview: PreviewProvider{
    static var previews: some View {
        HomeView()
    }
}
