#!/usr/bin/env node

// Toggle SealSuite VPN using Playwright to interact with Electron app
// This works in the background without stealing focus

const { _electron: electron } = require('playwright');
const { exec } = require('child_process');
const util = require('util');
const execPromise = util.promisify(exec);

async function toggleVPN() {
  try {
    // Find SealSuite process
    const { stdout: pid } = await execPromise('pgrep -x "SealSuite"');
    if (!pid.trim()) {
      console.log('SealSuite is not running');
      process.exit(1);
    }

    // Connect to running Electron app
    const appPath = '/Applications/SealSuite.app';
    const electronApp = await electron.launch({
      args: [appPath],
      env: process.env
    });

    // Get main window
    const window = await electronApp.firstWindow();

    // Try to find and click the VPN toggle
    // Look for toggle switch, button, or checkbox near "VPN Connectivity"
    const toggle = await window.locator('text=VPN Connectivity').locator('..').locator('[role="switch"]').first();

    if (await toggle.isVisible()) {
      await toggle.click();
      console.log('VPN toggle clicked successfully');
      process.exit(0);
    } else {
      console.log('Toggle not found');
      process.exit(1);
    }

  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

toggleVPN();
