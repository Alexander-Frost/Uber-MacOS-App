//
//  AppDelegate.swift
//  MacOobur
//
//  Created by Alex on 10/13/19.
//  Copyright © 2019 AlexMata. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Properties
    
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	let popOver = NSPopover()

    // MARK: - Actions
    
    @objc func togglePopover(_ sender: NSStatusBarButton) {
        if popOver.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    // MARK: - App Lifecycle
    
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		if let button = statusItem.button {
			button.image = NSImage(named: "steeringWheel_icon")
			button.action = #selector(togglePopover(_:))
		}
		popOver.contentViewController = PopOutViewController.freshController()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
    
    // MARK: - Methods

	func showPopover(sender: NSStatusBarButton) {
		popOver.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.minY)
	}

	func closePopover(sender: NSStatusBarButton) {
		popOver.performClose(sender)
	}

	func constructMenu() {
		let menu = NSMenu()

		menu.addItem(NSMenuItem(title: "Preferences", action: nil, keyEquivalent: ""))
		menu.addItem(.separator())
		menu.addItem(NSMenuItem(title: "Quit MacOobur", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))

		statusItem.menu = menu
	}

	func application(_ application: NSApplication, open urls: [URL]) {
		print("time to open urls: \(urls)")
	}

}

