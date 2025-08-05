//
//  KeyboardBlocker.swift
//  TapLocks
//
//  Created by KOMURCU on 29.06.2025.
//

import Foundation
import AppKit
import Cocoa

protocol KeyboardBlockerDelegate: AnyObject {
    func keyboardBlockerDidChangeState(isBlocking: Bool)
}

class KeyboardBlocker: ObservableObject {
    weak var delegate: KeyboardBlockerDelegate?

    @Published var isBlocking = false {
        didSet {
            if isBlocking {
                startBlocking()
            } else {
                stopBlocking()
            }
            delegate?.keyboardBlockerDidChangeState(isBlocking: isBlocking)
        }
    }

    private var eventTapThread: EventTapThread?

    func startBlocking() {
        guard eventTapThread == nil else { return }

        let thread = EventTapThread()
        eventTapThread = thread
        thread.start()
    }
    
    func isEventTapActive() -> Bool {
        return eventTapThread != nil
    }

    func stopBlocking() {
        guard let thread = eventTapThread else { return }

        thread.stopSafely()
        while thread.isExecuting {
            Thread.sleep(forTimeInterval: 0.05)
        }

        thread.cancel() // işaretle
        eventTapThread = nil
    }

}

func isEventTapAllowed() -> Bool {
    let eventMask = CGEventMask(1 << CGEventType.keyDown.rawValue)
    guard let eventTap = CGEvent.tapCreate(
        tap: .cghidEventTap,
        place: .headInsertEventTap,
        options: .listenOnly,
        eventsOfInterest: eventMask,
        callback: { _, _, event, _ in
            return Unmanaged.passUnretained(event)
        },
        userInfo: nil
    ) else {
        return false
    }
    CFMachPortInvalidate(eventTap)

    return true
}
