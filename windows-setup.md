# Windows Machine Setup

> Instructions for replicating the Claude Code + Obsidian memory bank setup
> on Windows Desktop and Windows Laptop.

---

## Prerequisites

- Obsidian installed and iCloud Drive synced (vault should appear automatically)
- Claude Code installed (`npm install -g @anthropic-ai/claude-code`)
- Node.js installed (required for Claude Code)

---

## Step 1 — Install the Obsidian MCP Plugin

1. Open Obsidian and open the **<your-vault-name>** vault
2. Go to **Settings → Community Plugins → Browse**
3. Search for **"Claude Code MCP"** (by iansinnott)
4. Install and enable it
5. Go to **Settings → Claude Code MCP** and confirm both green dots are showing:
   - WebSocket Server (Claude Code) — Running
   - MCP Server (HTTP/SSE transport) — Running on port 22360

---

## Step 2 — Configure Claude Code Global Settings

Create or edit `%USERPROFILE%\.claude\settings.json`:

```json
{
  "mcpServers": {
    "obsidian": {
      "type": "sse",
      "url": "http://localhost:22360/sse"
    }
  }
}
```

On Windows, `%USERPROFILE%` is typically `C:\Users\<your-username>`.

To open the file location:

```
Win + R → %USERPROFILE%\.claude → Enter
```

If the `.claude` folder doesn't exist, create it.

---

## Step 3 — Enable Auto-Connect

Open Windows Terminal (PowerShell) and run:

```powershell
claude
```

Once inside Claude Code, run:

```
/config
```

Find **Auto-connect to IDE** and set it to `true`.

---

## Step 4 — Test the Connection

1. Make sure Obsidian is open with the <your-vault-name> vault
2. Open Windows Terminal (PowerShell — NOT WSL)
3. Navigate to any project:
   ```powershell
   cd C:\Users\<your-username>\_development\01_Projects\Personal\01_Javascript\your-project-name
   ```
4. Run `claude`
5. Type `hi` and confirm Claude reads the vault files

---

## WSL Important Note

**Always run Claude Code from Windows Terminal (PowerShell or CMD), not WSL.**

iCloud Drive is not accessible from within WSL. The vault path
`C:\Users\<your-username>\iCloudDrive\...` does not exist inside WSL's filesystem.

You can still use WSL for development work — just launch Claude Code from
the Windows side when you need Obsidian MCP access.

To work on a WSL project with the memory bank:

1. Open Windows Terminal
2. Launch Claude Code from Windows Terminal pointed at the WSL project path:
   ```powershell
   claude --cwd \\wsl$\Ubuntu\home\<your-username>\projects\my-project
   ```

---

## Vault Path on Windows

The Obsidian vault iCloud path on Windows is typically:

```
C:\Users\<your-username>\iCloudDrive\iCloud~md~obsidian\Documents\<your-vault-name>
```

Note: iCloud Drive on Windows uses `iCloudDrive` not `Mobile Documents`.
The MCP plugin handles this automatically — you don't need to reference
this path manually unless debugging.

---

## Troubleshooting

**Obsidian not showing in `/ide` list:**

- Confirm Obsidian is open with the correct vault
- Check plugin settings — both green dots should be showing
- Confirm `settings.json` has the `mcpServers` entry for obsidian

**Vault files not found:**

- Check that iCloud has finished syncing on this machine
- Confirm the vault name matches exactly: `<your-vault-name>`

**Claude Code not found:**

- Run `npm install -g @anthropic-ai/claude-code` in PowerShell as Administrator
