#!/usr/bin/env node

import { createRequire } from "module";
import fs from "fs";
import path from "path";

const require = createRequire(import.meta.url);

// Fix for LightningCSS native binary not being found in pnpm installations
try {
	require("lightningcss");
	console.log("✅ LightningCSS is working correctly");
} catch (e) {
	if (e.message.includes("lightningcss.linux-x64-gnu.node")) {
		try {
			const binPath = path.join(
				process.cwd(),
				"node_modules/.pnpm/lightningcss-linux-x64-gnu@1.30.1/node_modules/lightningcss-linux-x64-gnu/lightningcss.linux-x64-gnu.node",
			);
			const targetPath = path.join(
				process.cwd(),
				"node_modules/.pnpm/lightningcss@1.30.1/node_modules/lightningcss/lightningcss.linux-x64-gnu.node",
			);

			if (fs.existsSync(binPath) && !fs.existsSync(targetPath)) {
				fs.copyFileSync(binPath, targetPath);
				console.log("🔧 Fixed LightningCSS binary path");

				// Test again
				try {
					require("lightningcss");
					console.log("✅ LightningCSS is now working correctly");
				} catch (testError) {
					console.warn("⚠️  LightningCSS still not working after fix:", testError.message);
				}
			} else {
				console.warn("⚠️  Could not locate LightningCSS binary files to fix");
			}
		} catch (err) {
			console.warn("⚠️  Could not fix LightningCSS binary:", err.message);
		}
	} else {
		console.warn("⚠️  LightningCSS error (not binary related):", e.message);
	}
}
