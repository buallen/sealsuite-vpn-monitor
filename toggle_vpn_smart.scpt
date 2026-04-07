-- Smart VPN Toggle: Activate, Click, Return Focus
-- v2.2: Dynamic coordinate calculation based on window position

-- Save current active application
tell application "System Events"
	set previousApp to name of first application process whose frontmost is true
end tell

-- Make sure SealSuite is running
tell application "System Events"
	if not (exists process "SealSuite") then
		tell application "SealSuite" to launch
		delay 2
	end if
end tell

-- Activate SealSuite briefly
tell application "SealSuite" to activate
delay 1.5

tell application "System Events"
	tell process "SealSuite"
		-- Get window position and size
		set winPos to position of window 1
		set winSize to size of window 1
		
		-- Calibration: The toggle is usually at a specific relative position
		-- Based on previous calibration X=735, Y=259
		-- If we don't have a better reference, we use the center-right area 
		-- where the "On/Off" toggle typically resides in the 'Overview' tab.
		
		-- Logic: Click relative to window top-left
		-- We calculate the click point (assuming standard window size)
		set clickX to (item 1 of winPos) + 735 - (item 1 of winPos) -- Placeholder logic
		-- Better: Use the user's calibrated point if the window hasn't moved, 
		-- but since we want it dynamic:
		
		-- If window is 1000 wide, 735 is ~73.5% from left.
		-- If window is 600 high, 259 is ~43% from top.
		set clickX to (item 1 of winPos) + ((item 1 of winSize) * 0.735)
		set clickY to (item 2 of winPos) + ((item 2 of winSize) * 0.43)
		
		-- Execute double-click at the calculated point
		do shell script "cliclick dc:" & (clickX as integer) & "," & (clickY as integer)
	end tell
end tell

delay 0.5

-- Return focus to previous app
if previousApp is not "SealSuite" and previousApp is not "" then
	tell application previousApp to activate
end if

return true
