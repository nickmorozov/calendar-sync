//
//  ContentView.swift
//  calendar-sync
//
//  Created by Nick Morozov on 2024-05-26.
//

import SwiftUI
import EventKit

struct SyncerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var logs: [String] = []

    var body: some View {
        VStack {
            List(logs, id: \.self) { log in
                Text(log)
            }
            Button(action: startSyncing) {
                Text("Start Syncing")
            }
        }
        .padding()
    }

    func startSyncing() {
        let fetcher = EventFetcher()
        let worker = Worker()

        fetcher.requestAccess { granted, error in
            guard granted, error == nil else {
                logs.append("Access denied or error occurred: \(String(describing: error))")
                return
            }

            let startDate = Date() // Adjust the date range as needed
            let endDate = Calendar.current.date(byAdding: .day, value: 2, to: startDate)!

            worker.performWork(startDate: startDate, endDate: endDate, fetcher: fetcher) { events, reminders in
                logs.append("Fetched \(events.count) events and \(reminders.count) reminders.")
                // Implement syncing logic here
            }
        }
    }
}
