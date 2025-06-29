//
//  ExerciseModel.swift
//  SweaySyncV2
//
//  Created by Pasindu Jayasinghe on 6/15/25.
//

import Foundation

struct ExerciseModel: Identifiable {
    let id = UUID()
    var name: String
    var sets: Int
    var reps: Int
}
