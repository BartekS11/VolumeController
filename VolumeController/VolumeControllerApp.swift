//
//  AppDelegate.swift
//  VolumeController
//
//  Created by Bartosz S on 14/11/2024.
//

import Cocoa
import SwiftUI
import AudioToolbox

@main
struct MenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var volumeMeter = VolumeMeter()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
                window.close()
            }
        // Create a status item with a fixed length (menu bar icon)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusBarButton = statusItem?.button {
            statusBarButton.image = NSImage(systemSymbolName: "pencil", accessibilityDescription: "Menu Bar App")
            statusBarButton.action = #selector(showMenu)
        }
        
        // Create the menu for the status item
        let menu = NSMenu()
        let volumeMeter = NSMenuItem()
        volumeMeter.view = createVolumeMeter()
        
        menu.addItem(volumeMeter)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Volume Controller", action: #selector(quitApp), keyEquivalent: "Q"))
        
        statusItem?.menu = menu
    }
    
    @objc func showMenu() {
        statusItem?.menu?.popUp(positioning: nil, at: NSPoint(x: 0, y: 0), in: statusItem?.button)
    }

    @objc func sayHello() {
        let alert = NSAlert()
        alert.messageText = "Hello, World!"
        alert.runModal()
    }
    
    @objc private func volumeSliderChanged(_ sender: NSSlider) {
          let newVolume = sender.doubleValue / 100.0
          volumeMeter.setSystemVolume(Float(newVolume))
      }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    private func createVolumeMeter() -> NSSlider {
        let volumeSlider = NSSlider(value: 50, minValue: 0, maxValue: 100, target: self, action: #selector(volumeSliderChanged(_:)))
        
        return volumeSlider
    }
}
