#!/bin/bash
# Fires automatically before Claude Code compacts the context window.
# Instructs Claude to flush important context to the Obsidian vault
# before detail is lost in compaction.

echo "IMPORTANT: Context window compaction is about to occur. Before compacting, immediately write any unlogged information to the Obsidian vault:"
echo ""
echo "1. If any bugs or gotchas were resolved since the last vault write, append them to:"
echo "   <your-vault-path>/11_Claude-Memory/lessons-learned.md"
echo ""
echo "2. If any significant architectural or technical decisions were made since the last vault write, append them to:"
echo "   <your-vault-path>/11_Claude-Memory/decisions-log.md"
echo ""
echo "3. Append a mid-session checkpoint entry to:"
echo "   <your-vault-path>/11_Claude-Memory/session-log.md"
echo "   Label it as: [Project Name] — [Date] — MID-SESSION CHECKPOINT"
echo "   Include: what has been completed so far, what is in progress, and what decisions or bugs were notable."
echo ""
echo "Do this now before compaction proceeds."
