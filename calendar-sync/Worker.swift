//
//  Worker.swift
//  calendar-sync
//
//  Created by Nick Morozov on 2024-05-26.
//

import Foundation
import EventKit

class Worker {
    private let queue = DispatchQueue(label: "net.nickmorozov.calendar-sync.worker", attributes: .concurrent)
    
    func performWork(startDate: Date, endDate: Date, fetcher: EventFetcher, completion: @escaping ([EKEvent], [EKReminder]) -> Void) {
        queue.async {
            let group = DispatchGroup()
            var events: [EKEvent] = []
            var reminders: [EKReminder] = []
            
            group.enter()
            fetcher.fetchEvents(startDate: startDate, endDate: endDate) { fetchedEvents in
                events = fetchedEvents
                group.leave()
            }
            
            group.enter()
            fetcher.fetchReminders(startDate: startDate, endDate: endDate) { fetchedReminders in
                reminders = fetchedReminders
                group.leave()
            }
            
            group.wait()
            completion(events, reminders)
        }
    }
}
