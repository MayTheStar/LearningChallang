//
//  ContentViewModel.swift
//  Learning
//
//  Created by May Bader Alotaibi on 25/04/1446 AH.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    @Published var goal: Goal = Goal()
    
    func updateGoalText(_ text: String) {
        goal.text = text
    }
    
    func selectTimeframe(_ timeframe: String) {
        goal.timeframe = timeframe
    }
}
