# AGENTS.md — Cubase 15 Pro Song-Projekt-Template

## What this repo is

A **Cubase DAW project template**, not a software project. There is no build system, no package manager, no tests, no linters. The only executable artifact is `cubase.sh`.

## `cubase.sh` — the only tool

```bash
./cubase.sh --title "Mein Song" [--artist "Name"] [--bpm 120] [--key D-Moll] [--template name] [--dir /path] [--git]
```

- `--title` is mandatory; everything else is optional.
- Default base path: `/Volumes/PROJECTS/Music/<Artist>/<Song>/` (or just `<Song>` without artist).
- Converts names to CamelCase (no spaces) for directories and `.cpr` files.
- **Never overwrites existing files** in the target directory. Re-running is safe.
- Template `.cpr` files are sourced from `$HOME/Library/Preferences/Cubase 15/Project Templates/`. Run `./cubase.sh --help` to list them.
- `--git` initializes a git repo in the new song directory with two commits (empty initial + template files).

## File types

- **`.cpr` files** are Cubase project files (binary RIFF-like format). They are **not tracked in git** — Cubase 15 Pro has built-in versioning (Ctrl+Alt+S).
- **`_Docs/*.md`** files use `{{PLACEHOLDER}}` syntax that `cubase.sh` fills in via `sed`.

## Git conventions

- Commit messages use emoji prefixes: `🎵`, `feat:`, `docs:`, `chore:`, `fix:`.
- Audio, video, artwork, sources, and refs are gitignored (too large); only `.gitkeep` placeholders are tracked.

## What NOT to do

- Don't run `npm`, `pip`, `cargo`, or any build/test/lint commands — this is not a code project.
- Don't modify template `.cpr` files unless the user explicitly asks.
- Don't add prose documentation files without being asked.
