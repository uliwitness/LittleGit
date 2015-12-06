//
//  GitFolderStatus.swift
//  LittleGit
//
//  Created by Uli Kusterer on 06/12/15.
//  Copyright © 2015 Uli Kusterer. All rights reserved.
//

import Foundation


enum GitFileState : String
{
	case Modified = "M"
	case Ignored = "!"
	case Unknown = "?"
	case Copied = "C"
	case Renamed = "R"
	case Added = "A"
	case Deleted = "D"
}


public class GitFileEntry : CustomDebugStringConvertible {
	init( url inPath : NSURL?, workingState inWorkingState : String, state inState : String ) { url = inPath; state = inState; workingState = inWorkingState }
	var url : NSURL?;
	var state : String = "";
	var workingState : String = "";

    public var debugDescription: String { get {
		return "GitFileEntry{\(workingState)|\(state)|\(url)}"
	} }
}


public class GitFolderStatus : NSObject {
	var		statuses : [GitFileEntry] = []
	var		folderURL : NSURL?
	
	func readStatus( inFolderURL : NSURL ) -> [GitFileEntry] {
		statuses = []
		
		let	folder = inFolderURL.absoluteURL.path!
		folderURL = inFolderURL
		
		let	task = NSTask()
		task.launchPath = "/Applications/Xcode.app/Contents/Developer/usr/bin/git" // /usr/bin/git uses xcrun, which isn't allowed for Sandbox use, so we use a com.apple.security.temporary-exception.files.absolute-path.read-only entitlement and hard-code the path to Git inside Xcode for now.
		task.arguments = [ "status", "--porcelain", "--ignored" ]
		task.currentDirectoryPath = folder
		
		let taskPipe = NSPipe()
		NSNotificationCenter.defaultCenter().addObserver( self, selector: "finishedReading:", name: NSFileHandleReadToEndOfFileCompletionNotification, object: taskPipe.fileHandleForReading )
		task.standardOutput = taskPipe
		let	taskFileHandle = taskPipe.fileHandleForReading

		task.launch()

		taskFileHandle.readToEndOfFileInBackgroundAndNotify()
		
		task.waitUntilExit()
		
		return statuses
	}
	
	func finishedReading( notif : NSNotification ) {
		let	taskData : NSData = (notif.userInfo! as NSDictionary)[NSFileHandleNotificationDataItem] as! NSData
		let taskDataString : NSString = NSString( data: taskData, encoding: NSUTF8StringEncoding )!
		let statusLines = taskDataString.componentsSeparatedByString("\n") as [NSString]
		for currLine in statusLines
		{
			if( currLine.length < 1 )
			{
				continue
			}
			
			let	fileName = currLine.substringFromIndex( 3 )
			let	fileState = currLine.substringToIndex( 1 )
			let	workingState = currLine.substringWithRange( NSRange( location: 1, length: 1 ) )
			
			statuses.append( GitFileEntry(url: folderURL?.URLByAppendingPathComponent(fileName), workingState: workingState, state: fileState) )
		}
	}
}