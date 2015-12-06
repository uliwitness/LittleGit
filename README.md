# LittleGit
A TortoiseSVN-like Finder badge plugin for Git on Mac.

# How to use it
Just build the LittleGitFinderSyncExtension target. If you run it with the debugger,
it will immediately be loaded into Finder and the hard-coded folder will have its
files badged according to their status.

# Is this ready for use?
No. Currently, this is just a proof-of-concept that does the hard part: Get the Git
status of a folder and provide the correct badges to Finder. The badges don't update
when anything changes, you need to re-open the Finder window to achieve that. Also,
subfolders currently don't work.

I'm not yet sure whether I want to finish this, it depends on how much I need a tool
like this. But if I don't, this should be a good starting point for someone else to
build from.

# License

	Copyright 2015 by Uli Kusterer.
	
	This software is provided 'as-is', without any express or implied
	warranty. In no event will the authors be held liable for any damages
	arising from the use of this software.
	
	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:
	
	   1. The origin of this software must not be misrepresented; you must not
	   claim that you wrote the original software. If you use this software
	   in a product, an acknowledgment in the product documentation would be
	   appreciated but is not required.
	
	   2. Altered source versions must be plainly marked as such, and must not be
	   misrepresented as being the original software.
	
	   3. This notice may not be removed or altered from any source
	   distribution.
