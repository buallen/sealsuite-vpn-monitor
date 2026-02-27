-- Smart VPN Toggle: Activate, Click, Return Focus
-- Minimizes interruption by quickly returning to previous app

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

-- Click the toggle at EXACT calibrated coordinates
-- User calibration: X=735, Y=259 (absolute screen coordinates)
-- Try double-click to ensure it registers
do shell script "cliclick dc:735,259"

delay 0.3

-- Return focus to previous app
if previousApp is not "SealSuite" and previousApp is not "" then
	tell application previousApp to activate
end if

return true
