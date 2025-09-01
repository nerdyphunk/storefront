#!/usr/bin/env node

/**
 * Graceful server wrapper for SvelteKit
 * Handles SIGINT/SIGTERM properly to avoid "Command failed" messages
 */

import { spawn } from 'child_process';
import process from 'process';

const args = process.argv.slice(2);
if (args.length === 0) {
  console.error('Usage: node graceful-server.js <command> [args...]');
  process.exit(1);
}

const [command, ...commandArgs] = args;

let childProcess = null;
let isShuttingDown = false;

// Function to gracefully shutdown
function gracefulShutdown(signal) {
  if (isShuttingDown) {
    console.log(`\n⚠️  Force killing process...`);
    process.exit(1);
  }
  
  isShuttingDown = true;
  console.log(`\n🛑 Received ${signal}, shutting down gracefully...`);
  
  if (childProcess && !childProcess.killed) {
    console.log('📦 Stopping server...');
    childProcess.kill(signal);
    
    // Give process 5 seconds to shut down gracefully
    const timeout = setTimeout(() => {
      if (!childProcess.killed) {
        console.log('⚠️  Force killing after timeout');
        childProcess.kill('SIGKILL');
      }
    }, 5000);
    
    childProcess.on('exit', (code, signal) => {
      clearTimeout(timeout);
      console.log('✅ Server stopped');
      process.exit(code === null ? 0 : code);
    });
  } else {
    process.exit(0);
  }
}

// Handle shutdown signals
process.on('SIGINT', () => gracefulShutdown('SIGINT'));
process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));

// Handle uncaught exceptions
process.on('uncaughtException', (err) => {
  console.error('Uncaught Exception:', err);
  gracefulShutdown('SIGTERM');
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  gracefulShutdown('SIGTERM');
});

// Spawn the child process
childProcess = spawn(command, commandArgs, {
  stdio: 'inherit',
  env: process.env
});

childProcess.on('error', (err) => {
  console.error('Failed to start child process:', err);
  process.exit(1);
});

childProcess.on('exit', (code, signal) => {
  if (!isShuttingDown) {
    if (signal) {
      console.log(`\nProcess exited with signal: ${signal}`);
    } else {
      console.log(`\nProcess exited with code: ${code}`);
    }
    process.exit(code === null ? 0 : code);
  }
});

console.log(`🚀 Started: ${command} ${commandArgs.join(' ')}`);
console.log('💡 Press Ctrl+C to stop gracefully');
