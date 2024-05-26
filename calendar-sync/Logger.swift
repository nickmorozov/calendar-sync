//
//  Logger.swift
//  calendar-sync
//
//  Created by Nick Morozov on 2024-05-26.
//

import Foundation

class Logger {
    static let shared = Logger()
    private init() {}

    func log(_ message: String) {
        print("[LOG] \(message)")
    }

    func error(_ message: String) {
        print("[ERROR] \(message)")
    }
}
