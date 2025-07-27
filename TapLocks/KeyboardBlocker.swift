//
//  KeyboardBlocker.swift
//  TapLocks
//
//  Created by KOMURCU on 29.06.2025.
//

import Foundation
import AppKit

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

        thread.stopSafely() // döngü durur

        // Thread'in gerçekten durmasını bekle
        while thread.isExecuting {
            Thread.sleep(forTimeInterval: 0.05)
        }

        thread.cancel() // işaretle
        eventTapThread = nil
    }

}

func isEventTapAllowed() -> Bool {
    let eventMask = (1 << CGEventType.keyDown.rawValue)
    let eventTap = CGEvent.tapCreate(
        tap: .cgSessionEventTap,
        place: .headInsertEventTap,
        options: .listenOnly,
        eventsOfInterest: CGEventMask(eventMask),
        callback: { _, _, _, _ in return nil },
        userInfo: nil
    )
    return eventTap != nil
}
