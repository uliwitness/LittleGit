//
//  FinderSync.swift
//  LittleGitFinderSyncExtension
//
//  Created by Uli Kusterer on 06/12/15.
//  Copyright © 2015 Uli Kusterer. All rights reserved.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    var myFolderURL: NSURL = NSURL(fileURLWithPath: "/Users/uli/Programming/Stacksmith")
	var statuses: [GitFileEntry] = []

    override init() {
        super.init()

        print("FinderSync() launched from \(NSBundle.mainBundle().bundlePath)")

        // Set up the directory we are syncing.
        FIFinderSyncController.defaultController().directoryURLs = [self.myFolderURL]
        
        // Set up images for our badge identifiers. For demonstration purposes, this uses off-the-shelf images.
        FIFinderSyncController.defaultController().setBadgeImage(NSImage(named: "Modified")!, label: "Modified" , forBadgeIdentifier: "Modified")
        FIFinderSyncController.defaultController().setBadgeImage(NSImage(named: "Ignored")!, label: "Ignored", forBadgeIdentifier: "Ignored")
        FIFinderSyncController.defaultController().setBadgeImage(NSImage(named: "Unknown")!, label: "Unknown", forBadgeIdentifier: "Unknown")
        FIFinderSyncController.defaultController().setBadgeImage(NSImage(named: "Renamed")!, label: "Renamed", forBadgeIdentifier: "Renamed")
        FIFinderSyncController.defaultController().setBadgeImage(NSImage(named: "Copied")!, label: "Copied", forBadgeIdentifier: "Copied")
        FIFinderSyncController.defaultController().setBadgeImage(NSImage(named: "Added")!, label: "Added", forBadgeIdentifier: "Added")
        FIFinderSyncController.defaultController().setBadgeImage(NSImage(named: "Deleted")!, label: "Deleted", forBadgeIdentifier: "Deleted")
    }

    // MARK: - Primary Finder Sync protocol methods

    override func beginObservingDirectoryAtURL(url: NSURL) {
        // The user is now seeing the container's contents.
        // If they see it in more than one view at a time, we're only told once.
        print("beginObservingDirectoryAtURL: \(url.filePathURL!)")
		
		statuses = GitFolderStatus().readStatus( url )
		print(statuses)
    }


    override func endObservingDirectoryAtURL(url: NSURL) {
        // The user is no longer seeing the container's contents.
        print("endObservingDirectoryAtURL: \(url.filePathURL!)")
		statuses = []
    }

    override func requestBadgeIdentifierForURL(url: NSURL) {
        //NSLog("requestBadgeIdentifierForURL: %@", url.filePathURL!)
		let	absolutePath = url.absoluteURL.path!	// Must compare path, we get short file://.file URLs that will compare as false otherwise.
		
		for currStatus in statuses {
			if( currStatus.url!.path!.isEqual( absolutePath ) )
			{
				print("\(absolutePath): \(currStatus.state)")
				if currStatus.state == GitFileState.Modified.rawValue
				{
					FIFinderSyncController.defaultController().setBadgeIdentifier("Modified", forURL: url)
				}
				else if currStatus.state == GitFileState.Ignored.rawValue
				{
					FIFinderSyncController.defaultController().setBadgeIdentifier("Ignored", forURL: url)
				}
				else if currStatus.state == GitFileState.Unknown.rawValue
				{
					FIFinderSyncController.defaultController().setBadgeIdentifier("Unknown", forURL: url)
				}
				else if currStatus.state == GitFileState.Copied.rawValue
				{
					FIFinderSyncController.defaultController().setBadgeIdentifier("Copied", forURL: url)
				}
				else if currStatus.state == GitFileState.Renamed.rawValue
				{
					FIFinderSyncController.defaultController().setBadgeIdentifier("Renamed", forURL: url)
				}
				else if currStatus.state == GitFileState.Added.rawValue
				{
					FIFinderSyncController.defaultController().setBadgeIdentifier("Added", forURL: url)
				}
				else if currStatus.state == GitFileState.Deleted.rawValue
				{
					FIFinderSyncController.defaultController().setBadgeIdentifier("Deleted", forURL: url)
				}
			}
		}
	}

    // MARK: - Menu and toolbar item support

    override var toolbarItemName: String {
        return "LittleGitFinderSyncExtension"
    }

    override var toolbarItemToolTip: String {
        return "LittleGitFinderSyncExtension: Click the toolbar item for a menu."
    }

    override var toolbarItemImage: NSImage {
        return NSImage(named: NSImageNameCaution)!
    }

    override func menuForMenuKind(menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "")
        menu.addItemWithTitle("Example Menu Item", action: "sampleAction:", keyEquivalent: "")
        return menu
    }

    @IBAction func sampleAction(sender: AnyObject?) {
        let target = FIFinderSyncController.defaultController().targetedURL()
        let items = FIFinderSyncController.defaultController().selectedItemURLs()

        let item = sender as! NSMenuItem
        print("sampleAction: menu item: \(item.title), target = \(target!.filePathURL!), items = ")
        for obj in items! {
            print("    \(obj.filePathURL!)")
        }
    }

}

