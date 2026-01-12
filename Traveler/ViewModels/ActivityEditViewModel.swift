//
//  ActivityEditViewModel.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//

import Foundation
import SwiftData
internal import Combine

@MainActor
final class ActivityEditViewModel: ObservableObject {

    @Published var activity: Activity

    init(activity: Activity?) {
        self.activity = activity ?? Activity()
    }
}
