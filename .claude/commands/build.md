---
description: Build the iOS project
allowed-tools: mcp__xcodebuildmcp__*, Bash(xcodegen *)
---

# Build Project

1. If project.yml was modified, regenerate project: `xcodegen generate`
2. Build for iOS Simulator using XcodeBuildMCP: `mcp__xcodebuildmcp__build_sim_name_proj`
3. Report any build errors with suggested fixes
