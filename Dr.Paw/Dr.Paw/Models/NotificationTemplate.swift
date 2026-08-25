//
//  NotificationTemplate.swift
//  Dr.Paw
//
//  Created by Adityasinh on 24/08/26.
//

import Foundation

struct NotificationTemplate: Codable, Identifiable {
    let id: UUID
    let type: String
    let messages: [String]
}
