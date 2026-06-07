# Cubase 15 Pro — Song-Projekt-Template

> André Müller · Harmonic Seeds Studio · Cubase 15 Pro, Mackie DL16s

## Verwendung

1. Dieses Repo klonen oder als ZIP laden
2. Ordner umbenennen: `cubase-template` → `Mein Songtitel`
3. Cubase-Projekt im Ordner speichern
4. `_Docs/metadata.md` ausfüllen (Credits, ISRC, BPM, Key)
5. `_Docs/notes.md` für Recording-Session-Doku nutzen

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
│                           (Handy-Demos, Voice-Memos, Referenzen)
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
