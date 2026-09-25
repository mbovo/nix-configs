#!/usr/bin/env python3
"""Report which Homebrew formulae/casks lack a prebuilt macOS bottle for an architecture.

Usage: scripts/check_brew_bottles.py [--arch x86_64|arm64] name [name ...]
Casks are prefixed with "cask:". Tapped formulae (with "/") are skipped: taps ship their own binaries.
Homebrew pours a bottle built for an older macOS on newer releases, so any same-arch macOS tag counts.
"""
import argparse
import json
import sys
import urllib.error
import urllib.request

API = "https://formulae.brew.sh/api"


def fetch(kind, name):
    with urllib.request.urlopen(f"{API}/{kind}/{name}.json", timeout=30) as resp:
        return json.load(resp)


def macos_tags(files, arch):
    tags = [t for t in files if "linux" not in t]
    if arch == "arm64":
        return [t for t in tags if t.startswith("arm64_") or t == "all"]
    return [t for t in tags if not t.startswith("arm64_")]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--arch", default="x86_64", choices=["x86_64", "arm64"])
    parser.add_argument("names", nargs="+")
    args = parser.parse_args()

    problems = []
    for name in args.names:
        if name.startswith("cask:"):
            token = name.removeprefix("cask:")
            try:
                data = fetch("cask", token)
            except urllib.error.HTTPError:
                problems.append(f"{name}: not found")
                continue
            arch = data.get("depends_on", {}).get("arch")
            ok = not arch or args.arch in str(arch)
            status = "ok" if ok else f"not available for {args.arch}"
        elif "/" in name:
            status = "tap (skipped)"
            ok = True
        else:
            try:
                data = fetch("formula", name)
            except urllib.error.HTTPError:
                problems.append(f"{name}: not found in homebrew/core")
                continue
            tags = macos_tags(data.get("bottle", {}).get("stable", {}).get("files", {}), args.arch)
            ok = bool(tags)
            status = f"bottle ({tags[0]})" if ok else "SOURCE BUILD"
            if data.get("disabled"):
                ok, status = False, "DISABLED"
            elif data.get("deprecated"):
                status += f" (deprecated {data.get('deprecation_date')})"
        print(f"{name:32} {status}")
        if not ok:
            problems.append(f"{name}: {status}")

    if problems:
        print("\nNeeds attention on macOS", args.arch, ":\n  " + "\n  ".join(problems))
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
