//
//  TapLocksApp.swift
//  TapLocks
//
//  Created by KOMURCU on 27.07.2025.
//

import SwiftUI

@main
struct MacLockAppApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView() // Ayarlar penceresi yerine hiçbir pencere açılmasın
        }
    }
}
