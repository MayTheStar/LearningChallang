//
//  DayStatus.swift
//  Learning
//
//  Created by May Bader Alotaibi on 25/04/1446 AH.
//

// DayStatus.swift
import Foundation

struct DayStatus: Identifiable {
    let id = UUID()
    let date: Date
    var isLearningDay: Bool = false
    var isFreezeDay: Bool = false
}
