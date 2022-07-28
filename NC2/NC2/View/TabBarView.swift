//
//  TabBarView.swift
//  NC2
//
//  Created by Evelin Evelin on 20/07/22.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "clock.fill")
                }
        }
        .accentColor(.newPink)
        .onAppear {
            NotifManager.shared.getAuth()
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
