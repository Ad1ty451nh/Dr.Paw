//
//  DrPawWidgetBundle.swift
//  DrPawWidget
//

import SwiftUI
import WidgetKit

@main
struct DrPawWidgetBundle: WidgetBundle {
    var body: some Widget {
        FoodWalkWidget()
        MedicalVisitWidget()
        DrPawWidgetLiveActivity()
    }
}
