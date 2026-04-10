-- Smart VPN Toggle: Activate, Click, Return Focus
-- v2.4: More robust window detection and focus restoration

-- Save current active application
tell application "System Events"
	set previousApp to name of first application process whose frontmost is true
end tell

-- Make sure SealSuite is running and has a window
tell application "SealSuite"
	reopen
	activate
end tell

delay 2

tell application "System Events"
	tell process "SealSuite"
		-- Check if window exists, if not, try to reopen one more time
		if not (exists window 1) then
			tell application "SealSuite" to reopen
			delay 2
		end if
		
		if exists window 1 then
			-- Get window position and size
			set winPos to position of window 1
			set winSize to size of window 1
			
			-- Logic: Click relative to window top-left
			-- If window is 1000 wide, toggle is ~73.5% from left.
			-- If window is 600 high, toggle is ~43% from top.
			set clickX to (item 1 of winPos) + ((item 1 of winSize) * 0.735)
			set clickY to (item 2 of winPos) + ((item 2 of winSize) * 0.43)
			
			-- Execute double-click at the calculated point
			do shell script "/opt/homebrew/bin/cliclick dc:" & (clickX as integer) & "," & (clickY as integer)
		else
			error "Could not find SealSuite window after multiple attempts."
		end if
	end tell
end tell

delay 0.5

-- Return focus to previous app
if previousApp is not "SealSuite" and previousApp is not "" then
	tell application previousApp to activate
end if

return true
