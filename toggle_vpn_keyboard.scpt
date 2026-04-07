-- Toggle VPN using keyboard navigation instead of mouse
-- More reliable for Electron apps

-- Save current active application
tell application "System Events"
	set previousApp to name of first application process whose frontmost is true
end tell

-- Activate SealSuite
tell application "SealSuite" to activate
delay 1

tell application "System Events"
	tell process "SealSuite"
		-- Tab to the VPN toggle (it's usually the first or second focusable element)
		-- Try tabbing to it and pressing Space/Enter

		-- Method 1: Tab navigation
		keystroke tab
		delay 0.3
		keystroke tab
		delay 0.3
		keystroke space
		delay 0.5
	end tell
end tell

-- Return focus to previous app
if previousApp is not "SealSuite" and previousApp is not "" then
	tell application previousApp to activate
end if

return true
