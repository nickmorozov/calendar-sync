//
//  EventFetcher.swift
//  calendar-sync
//
//  Created by Nick Morozov on 2024-05-26.
//

import Foundation
import EventKit

class EventFetcher {
    private let eventStore = EKEventStore()

    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            completion(granted, error)
        }
    }

    func fetchEvents(startDate: Date, endDate: Date, completion: @escaping ([EKEvent]) -> Void) {
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = eventStore.events(matching: predicate)
        completion(events)
    }

    func fetchReminders(startDate: Date, endDate: Date, completion: @escaping ([EKReminder]) -> Void) {
        let calendars = eventStore.calendars(for: .reminder)
        let predicate = eventStore.predicateForReminders(in: calendars)
        eventStore.fetchReminders(matching: predicate) { reminders in
            guard let reminders = reminders else {
                completion([])
                return
            }
            let filteredReminders = reminders.filter { reminder in
                guard let dueDate = reminder.dueDateComponents?.date else { return false }
                return dueDate >= startDate && dueDate <= endDate
            }
            completion(filteredReminders)
        }
    }
}
