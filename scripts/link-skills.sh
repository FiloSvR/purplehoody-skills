#!/usr/bin/env bash
# Links every skill in this repo into a tool's skill folder, so `git pull` updates them.
# Usage: scripts/link-skills.sh [folder]   (default: ~/.claude/skills). Safe to run again.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
dest=${1:-$HOME/.claude/skills}
mkdir -p "$dest"
for skill in "$root"/skills/*/; do
	name=$(basename "$skill")
	ln -sfn "${skill%/}" "$dest/$name"
	echo "linked $name -> $dest"
done
