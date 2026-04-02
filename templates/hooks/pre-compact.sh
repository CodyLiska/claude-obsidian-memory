#!/bin/bash
# Fires automatically before Claude Code compacts the context window.
# Reads the session JSONL transcript, generates a checkpoint via claude -p,
# and writes it directly to the Obsidian vault — guaranteed before compaction.

# ** UPDATE THE VAULT PATH BELOW TO YOUR VAULT LOCATION BEFORE USING **
VAULT="<your-vault-path>"

HOOK_DIR="$(dirname "$0")"
LOG="$HOME/.claude/pre-compact.log"
SESSION_LOG="$VAULT/session-log.md"
SESSION_STATE="$VAULT/session-state.md"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] pre-compact fired" >> "$LOG"

# Read the JSON payload Claude Code sends on stdin
PAYLOAD=$(cat)

# Try to extract session_id from the payload
SESSION_ID=$(echo "$PAYLOAD" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('session_id', ''))
except:
    print('')
" 2>>"$LOG")

echo "[$(date '+%Y-%m-%d %H:%M:%S')] session_id=${SESSION_ID}" >> "$LOG"

# Find the transcript JSONL using session_id
TRANSCRIPT=""
if [ -n "$SESSION_ID" ]; then
  TRANSCRIPT=$(find "$HOME/.claude/projects" -name "${SESSION_ID}.jsonl" 2>/dev/null | head -1)
fi

# Fallback: most recently modified top-level JSONL (not subagents)
if [ -z "$TRANSCRIPT" ]; then
  TRANSCRIPT=$(find "$HOME/.claude/projects" -maxdepth 2 -name "*.jsonl" -not -path "*/subagents/*" 2>/dev/null \
    | xargs ls -t 2>/dev/null | head -1)
fi

if [ -z "$TRANSCRIPT" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: no transcript found, skipping" >> "$LOG"
  exit 0
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] transcript=${TRANSCRIPT}" >> "$LOG"

# Extract the working directory from the transcript to identify the project
CWD=$(python3 -c "
import sys, json
path = sys.argv[1]
try:
    with open(path) as f:
        for line in f:
            try:
                obj = json.loads(line)
                if obj.get('type') == 'user' and obj.get('cwd'):
                    print(obj['cwd'])
                    break
            except:
                pass
except Exception as e:
    print('', file=sys.stderr)
" "$TRANSCRIPT" 2>>"$LOG")

echo "[$(date '+%Y-%m-%d %H:%M:%S')] cwd=${CWD}" >> "$LOG"

# Generate the checkpoint — capture output before writing to validate format
CHECKPOINT_OUTPUT=$(python3 "$HOOK_DIR/extract_transcript.py" "$TRANSCRIPT" 2>>"$LOG" | \
  claude -p "You are writing a mid-session checkpoint for an Obsidian vault session log.

The transcript below is from an active Claude Code session working in: ${CWD}

Produce ONLY a session log entry in this exact format — no preamble, no explanation, nothing else:

### [Project Name] — $(date '+%Y-%m-%d') — MID-SESSION CHECKPOINT

**Goal:** What the session set out to accomplish
**Completed:** What was actually finished so far
**In progress / left incomplete:** What was started but not finished
**Decisions made:** Any notable choices made (or 'None' if none)
**Next session should:** Specific recommended starting point
**Blockers:** Anything unresolved (or 'None')

Infer the project name from the working directory path or conversation context. Be factual and brief. Use past tense for completed items.

TRANSCRIPT:
" --model claude-haiku-4-5-20251001 2>>"$LOG")

# Validate output starts with ### before writing to session-log
# If malformed, write to error log instead to prevent log pollution
if echo "$CHECKPOINT_OUTPUT" | grep -q "^### "; then
  # Write checkpoint to temp file to avoid shell escaping issues in Python
  TMPCHECKPOINT=$(mktemp)
  echo "$CHECKPOINT_OUTPUT" > "$TMPCHECKPOINT"

  # Prepend after the "## Log" header so newest entries stay at the top
  python3 - "$SESSION_LOG" "$TMPCHECKPOINT" << 'PYEOF'
import sys

log_path = sys.argv[1]
checkpoint_path = sys.argv[2]

with open(checkpoint_path, 'r') as f:
    checkpoint = f.read().strip()

with open(log_path, 'r') as f:
    content = f.read()

marker = '## Log\n\n'
idx = content.find(marker)
if idx == -1:
    # Fallback: append if marker not found
    with open(log_path, 'a') as f:
        f.write('\n' + checkpoint + '\n\n---\n\n')
else:
    insert_at = idx + len(marker)
    new_content = content[:insert_at] + checkpoint + '\n\n---\n\n' + content[insert_at:]
    with open(log_path, 'w') as f:
        f.write(new_content)
PYEOF

  rm -f "$TMPCHECKPOINT"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] checkpoint written to session-log.md" >> "$LOG"

  # Rotate session-log if entry count exceeds MAX_ENTRIES
  # Moves oldest entries to session-log-archive.md, keeps log lean
  SESSION_LOG_ARCHIVE="$VAULT/session-log-archive.md"
  python3 - "$SESSION_LOG" "$SESSION_LOG_ARCHIVE" << 'PYEOF'
import sys, re

MAX_ENTRIES = 15
log_path = sys.argv[1]
archive_path = sys.argv[2]

with open(log_path, 'r') as f:
    content = f.read()

# Split into header (everything up to and including "## Log\n\n") and body
marker = '## Log\n\n'
idx = content.find(marker)
if idx == -1:
    sys.exit(0)

header = content[:idx + len(marker)]
body = content[idx + len(marker):]

# Split entries on ### boundaries, preserving the ### prefix
parts = re.split(r'(?=^### )', body, flags=re.MULTILINE)
entries = [p for p in parts if p.strip()]

if len(entries) <= MAX_ENTRIES:
    sys.exit(0)

keep = entries[:MAX_ENTRIES]
rotate = entries[MAX_ENTRIES:]

# Prepend rotated entries to archive (newest-first order preserved)
archive_block = ''.join(rotate)
if not archive_block.endswith('\n'):
    archive_block += '\n'

if sys.path and __import__('os').path.exists(archive_path):
    with open(archive_path, 'r') as f:
        existing_archive = f.read()
    archive_marker = '## Log\n\n'
    a_idx = existing_archive.find(archive_marker)
    if a_idx != -1:
        insert_at = a_idx + len(archive_marker)
        new_archive = existing_archive[:insert_at] + archive_block + existing_archive[insert_at:]
    else:
        new_archive = existing_archive + '\n' + archive_block
else:
    new_archive = '# Session Log Archive\n\n> Entries rotated from session-log.md automatically.\n\n---\n\n## Log\n\n' + archive_block

with open(archive_path, 'w') as f:
    f.write(new_archive)

# Rewrite session-log.md with only the kept entries
with open(log_path, 'w') as f:
    f.write(header + ''.join(keep))

print(f'rotated {len(rotate)} entries to archive, kept {len(keep)}')
PYEOF

  ROTATE_RESULT=$?
  if [ $ROTATE_RESULT -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] session-log rotation check complete" >> "$LOG"
  fi
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: checkpoint output malformed, not written to session-log" >> "$LOG"
  echo "--- MALFORMED OUTPUT ---" >> "$LOG"
  echo "$CHECKPOINT_OUTPUT" >> "$LOG"
  echo "--- END MALFORMED OUTPUT ---" >> "$LOG"
fi

# Write a recovery checkpoint to session-state.md so Claude can recover
# context after compaction by re-reading this file
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')

if [ ! -f "$SESSION_STATE" ]; then
  echo "# Session State" > "$SESSION_STATE"
  echo "" >> "$SESSION_STATE"
  echo "> Auto-created by pre-compact hook" >> "$SESSION_STATE"
fi

cat >> "$SESSION_STATE" << EOF

---

## Compaction Checkpoint — $TIMESTAMP

**Note:** Context was compacted. Re-read this file and the project CLAUDE.md
to recover working state. Check the project file in projects/ for deep context
if needed.

EOF

echo "[$(date '+%Y-%m-%d %H:%M:%S')] recovery checkpoint written to session-state.md" >> "$LOG"
echo "PreCompact: checkpoint written to session-state.md at $TIMESTAMP"
