#!/usr/bin/env python3
# Written by Gemini/Google AI, but reviewed by myself (tux-linux)
import sys
import os
import subprocess

STATE_FILE = os.path.expanduser("/tmp/eww_data/saved_state.txt")

def save_state():
    """Captures raw state dump directly from eww."""
    try:
        raw_state = subprocess.check_output(["eww", "state"], text=True)
        os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
        with open(STATE_FILE, "w") as f:
            f.write(raw_state)
        print(f"State saved cleanly to {STATE_FILE}")
    except Exception as e:
        print(f"Error saving state: {e}", file=sys.stderr)
        sys.exit(1)

def restore_state():
    """Parses raw text file line-by-line and pushes single updates to eww."""
    if not os.path.exists(STATE_FILE):
        print(f"Error: No state file found at {STATE_FILE}", file=sys.stderr)
        sys.exit(1)

    update_args = []

    with open(STATE_FILE, "r") as f:
        for line in f:
            line = line.strip()
            
            # Skip invalid lines or shell prompt headers
            if not line or ":" not in line or line.startswith(">"):
                continue
                
            # Split strictly on the FIRST colon to prevent cutting path strings
            key, val = line.split(":", 1)
            key = key.strip()
            val = val.strip()

            # Ignore Eww's internal read-only metrics
            if key.startswith("EWW_"):
                continue

            # Shell format escaping rules
            if val.startswith("{") or val.startswith("["):
                # Complex JSON structures (Keep literal text matching eww output format)
                update_args.append(f"{key}='{val}'")
            elif val.lower() in ["true", "false"] or val.isdigit():
                # Raw numbers or structural booleans
                update_args.append(f"{key}={val}")
            else:
                # Standard raw text strings (wrap in safe single quotes)
                update_args.append(f"{key}='{val}'")

    if update_args:
        # Build a single unified bash command execution loop
        cmd = f"eww update {' '.join(update_args)}"
        subprocess.run(cmd, shell=True)
        print(f"Successfully synchronized {len(update_args)} state variables!")
    else:
        print("No valid state data matched parsing logic.")

if __name__ == "__main__":
    if len(sys.argv) < 2 or sys.argv[1] not in ["save", "restore"]:
        print("Usage: ./restore_state.py [save|restore]")
        sys.exit(1)

    if sys.argv[1] == "save":
        save_state()
    else:
        restore_state()

