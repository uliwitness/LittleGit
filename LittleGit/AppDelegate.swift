//
//  AppDelegate.swift
//  LittleGit
//
//  Created by Uli Kusterer on 06/12/15.
//  Copyright © 2015 Uli Kusterer. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let	folderStatus = GitFolderStatus()
		let statuses = folderStatus.readStatus(NSURL(fileURLWithPath: "/Users/uli/Programming/Stacksmith"))
		print(statuses)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
}

