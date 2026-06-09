# Cubase 15 Pro — Song-Projekt-Template

> André Müller · Harmonic Seeds Studio · Cubase 15 Pro, Mackie DL16s

## Verwendung

### Per Skript (empfohlen)

```bash
# Neuen Song anlegen
./cubase.sh --title "Mein neuer Song" --artist "Anna Beispiel" --bpm 128 --key "D-Moll"

# Mit anderem Template
./cubase.sh --title "Grainfield Live" --template grainfield --dir ~/Musik/

# Alle Optionen
./cubase.sh --help
```

**Optionen:**

| Option | Pflicht? | Default | Beschreibung |
|---|---|---|---|
| `--title` | ✅ | — | Songtitel (wird Verzeichnisname) |
| `--artist` | — | — | Interpret (in metadata.md) |
| `--bpm` | — | — | Geschwindigkeit |
| `--key` | — | — | Tonart (z.B. `D-Moll`) |
| `--template` | — | `default` | `.cpr`-Vorlage aus `templates/` |
| `--dir` | — | `/Volumes/PROJECTS/Music/…` | Basis-Pfad überschreiben |

**Was das Skript tut:**
- Erstellt Verzeichnis unter `/Volumes/PROJECTS/Music/<Artist>/<Song>/` (CamelCase)
- Ohne `--artist`: `/Volumes/PROJECTS/Music/<Song>/`
- Mit `--dir`: Basis-Pfad frei überschreibbar
- Kopiert die Ordner-Struktur (`_Docs`, `_Sources`, `_Refs`, …)
- Kopiert das gewählte `.cpr`-Template und benennt es CamelCase nach dem Songtitel
- Befüllt `metadata.md` und `versions.md` mit den angegebenen Werten
- **Überschreibt NIE bestehende Dateien** — bei erneutem Aufruf werden nur neue Dateien ergänzt

### Manuell

1. Repo klonen oder als ZIP laden
2. Ordner umbenennen: `cubase-template` → `Mein Songtitel`
3. Cubase-Projekt im Ordner speichern
4. `_Docs/metadata.md` ausfüllen

## Ordnerstruktur

```
Mein Songtitel/
├── 📁 Audio/              ← Cubase (Aufnahmen)
├── 📁 Edits/              ← Cubase (Stems, Freeze)
├── 📁 Images/             ← Cubase (Screenshots)
├── 📁 Mixdown/            ← Cubase: Audio Mixdown (automatisch!)
│   │                       Export-Ziel für ALLE Bounces
│   ├── Mixes/            ← Hörproben, Zwischenstände
│   ├── Stems/            ← Gruppenspuren
│   └── Masters/          ← fertig gemastert
│
├── 📁 Track Pictures/     ← Cubase (Track-Icons)
├── 📁 Auto Saves/         ← Cubase (automatisch)
│
├── 📁 _Sources/           ← Rohmaterial von extern
│                           (Handy-Demos, Voice-Memos)
│
├── 📁 _Refs/              ← Referenztracks von Künstlern
│                           (Stimmung, Sound, Mix-Ästhetik)
│
├── 📁 _Docs/              ← Text, Metadaten
│   ├── metadata.md       ← ISRC, Credits, BPM, Key
│   ├── lyrics.txt        ← Songtext
│   ├── notes.md          ← Recording-Session-Doku
│   └── versions.md       ← Cubase-Versions-Logbuch
│
├── 📁 _Notation/          ← Leadsheets, Scores
├── 📁 _Video/             ← Live-Mitschnitte
└── 📁 _Artwork/           ← Cover, Release-Grafiken
│
├── cubase.sh              ← Skript: neuen Song anlegen
└── templates/             ← .cpr-Vorlagen
```

## Recording-Pegel

- **Peak:** −12 dBFS (nie über −6!)
- **RMS:** −18 dBFS (~0 VU)
- **True Peak:** automatisch safe bei diesen Werten
- **Gain NICHT zwischen Takes ändern**

→ Vollständige Referenz: [[Recording Levels]] (Logseq)

## Mixing & Mastering

- Mixing-Workflow: [[Mixing Workflow]] (OMF 12 Schritte)
- Mastering-Workflow: [[Mastering Workflow Kurzsheet]] (Tyson's 70s Polish)
- Dynamik-Referenz: [[Youlean Loudness Meter Dynamik-Referenz]]
- Gain-Staging: [[Cubase Gain Staging und Normalize]]

## Equipment

→ Kanonische Liste: [`/data/business/reference/Equipment List.md`](https://github.com/harmonic-seeds/business-briefing/blob/main/reference/Equipment%20List.md)
