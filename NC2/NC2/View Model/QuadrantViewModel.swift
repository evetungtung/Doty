//
//  QuadrantViewModel.swift
//  NC2
//
//  Created by Evelin Evelin on 28/07/22.
//

import Foundation

class QuadrantViewModel: ObservableObject {
    @Published var dataQuadrant: [DataQuadrant] = [DataQuadrant]()

    func getAllQuadrant(){
        dataQuadrant = CoreDataManager.shared.getAllQuadrant()
        for dataQuadrant in dataQuadrant {
            print("Data Quadrant: \(dataQuadrant.name)")
        }
    }
    
    func initQuadrantData(){
        if(dataQuadrant.isEmpty){
            print("EMPTY")
            
            CoreDataManager.shared.quadrantInit()
        
            CoreDataManager.shared.saveContext()
            getAllQuadrant()
        }
    }
}
