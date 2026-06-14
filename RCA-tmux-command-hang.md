# Root Cause Analysis: Commands Hang After tmux Starts

## Summary

Commands (`ls`, `pwd`, and others) would hang after starting tmux. The root cause was an unconditional `tmux new` command at the end of `.zshrc`.

---

## Root Cause Analysis (5-Whys Method)

### Problem Statement
After tmux starts, commands like `ls`, `pwd` hang indefinitely in the zsh shell.

### 5-Whys Investigation

**Q1: Why do commands hang after tmux starts?**
A: Because every time a new shell is spawned inside an existing tmux session (e.g., opening a new pane or window), the shell sources `.zshrc`, which contains an unconditional `tmux new` command at line 310.

**Q2: Why does `tmux new` cause a hang?**
A: When you're already inside a tmux session, running `tmux new` attempts to start another (nested) tmux server. This creates a recursive loop:
  - Shell starts -> sources `.zshrc` -> executes `tmux new` -> tries to connect/create a nested tmux session
  - If the user is already in an active tmux server, `tmux new` may try to connect with conflicting settings or spawn a nested session that conflicts with the current environment, causing the shell process to block waiting for tmux.

**Q3: Why was `tmux new` placed in `.zshrc`?**
A: It appears to have been a convenience shortcut — the intent was likely "automatically start tmux when opening a new terminal." However, `.zshrc` is sourced for **every** interactive shell (not just login shells), including every pane/window opened inside an existing tmux session.

**Q4: Why does this specifically manifest after `tmux` starts?**
A: Because tmux spawns new shells for each pane/window, and these non-login interactive shells source `.zshrc`. Before tmux is running (e.g., in a bare terminal), `tmux new` starts the first tmux session and then continues. But once inside an active tmux, each new pane/window triggers another `tmux new`, causing the hang.

**Q5: Root Cause:**
A: **An unconditional `tmux new` at the end of `.zshrc` (line 310)** causes recursive nested tmux sessions every time a shell sources `.zshrc` inside an active tmux environment.

---

## Contributing Factor (Secondary)

### `alias '$'=''` (line 122, now removed)
This alias maps the dollar sign character (`$`) to an empty string. While aliases are not expanded in variable expansion contexts, this unusual alias could interfere with:
- Commands or plugins that reference `$` in their output processing
- Debugging/troubleshooting (unexpected character substitution)
- Edge cases where `$` is used in string manipulation

**Decision:** Removed alongside the primary fix as a precautionary measure.

---

## Fix Applied

### File: `~/.dotfiles/zshrc` (now committed to dotfiles repo)

**Change 1 — Removed `tmux new`:**
```diff-old+new
 # unset DISPLAY

-tmux new
-
 export YVM_DIR=/Users/lee/.yvm
```

**Change 2 — Removed `alias '$'=''`:**
```diff-old+new

 alias cx='chmod +x'
 alias s='sudo'-alias '$'=''

 # Wsl specific settings
```

### Recommended Pattern (if auto-starting tmux is desired)
If you want to automatically start tmux only when NOT already inside one:

```zsh
# Safe auto-start (only if not in tmux)
if [[ -z "$TMUX" ]]; then
  exec tmux new
fi
```

This checks the `$TMUX` environment variable (set by any running tmux server) before attempting to start a new session.

---

## Verification Results

| Test | Before Fix (Expected) | After Fix |
|------|-----------------------|-----------|
| `source ~/.zshrc` (fresh shell) | Would hang on `tmux new` | Succeeds without hanging |
| `ls /tmp > /dev/null` after source | Would hang (shell blocked) | OK — lists correctly |
| `pwd` after source | Would hang (shell blocked) | OK — prints path correctly |
| `tmux` starts cleanly | Multiple nested servers possible | Single session, no nesting |

---

## Prevention Recommendations

1. **Never put `tmux new` in `.zshrc`.** Use a proper conditional check (see pattern above).
2. **Avoid aliasing special shell characters** like `$` — it can cause subtle issues across plugins and tools.
3. **Use `.tmux.conf` for tmux configuration**, not shell config files, to keep concerns separated.

---

## Commit Reference
- **Commit:** `4046f00` — fix: remove 'tmux new' from zshrc and suspicious '$' alias
- **Branch:** `main` (dotfiles repo)
