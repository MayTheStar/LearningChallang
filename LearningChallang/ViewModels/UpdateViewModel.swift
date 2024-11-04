//
//  UpdateViewModel.swift
//  Learning
//
//  Created by May Bader Alotaibi on 25/04/1446 AH.
//

import SwiftUI
import Combine

 

class UpdateViewModel: ObservableObject {
    @Published var goal: Goal = Goal()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func updateGoalText(_ text: String) {
        goal.text = text
    }
    
    func selectTimeframe(_ timeframe: String) {
        goal.timeframe = timeframe
    }
}

