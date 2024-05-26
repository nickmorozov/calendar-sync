//
//  ContentView.swift
//  calendar-sync
//
//  Created by Nick Morozov on 2024-05-26.
//

import SwiftUI

struct ContentView: View {
    @State private var logs: [String] = []

    var body: some View {
        VStack {
            List(logs.indices, id: \.self) { index in
                Text(logs[index])
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
            DispatchQueue.main.async {
                if granted {
                    let startDate = Date() // Adjust the date range as needed
                    let endDate = Calendar.current.date(byAdding: .day, value: 2, to: startDate)!

                    worker.performWork(startDate: startDate, endDate: endDate, fetcher: fetcher) { events, reminders in
                        DispatchQueue.main.async {
                            logs.append("Fetched \(events.count) events and \(reminders.count) reminders.")
                            Logger.shared.log("Fetched \(events.count) events and \(reminders.count) reminders.")
                            // Implement syncing logic here
                        }
                    }
                } else {
                    let errorMessage = "Access denied or error occurred: \(String(describing: error))"
                    logs.append(errorMessage)
                    Logger.shared.error(errorMessage)
                }
            }
        }
    }
}
