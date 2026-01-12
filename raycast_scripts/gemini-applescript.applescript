#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Gemini AS
# @raycast.mode silent

# Optional parameters:
# @raycast.argument1 { "type": "text", "placeholder": "Prompt" }

on run {input}
	set promptText to input
	
	tell application "Google Chrome"
		activate
		open location "https://gemini.google.com/app"
		delay 1.5
		
		tell application "System Events"
			keystroke promptText
			delay 0.1
			keystroke return
		end tell
	end tell
end run
