//
//  DrPawWidgetBundle.swift
//  DrPawWidget
//
//  Created by Adityasinh on 24/08/26.
//

import WidgetKit
import SwiftUI

@main
struct DrPawWidgetBundle: WidgetBundle {
    var body: some Widget {
        DrPawWidget()
        DrPawWidgetControl()
        DrPawWidgetLiveActivity()
    }
}
