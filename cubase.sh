#!/usr/bin/env bash
# ===================================================================
# cubase.sh — Neuen Song aus dem Cubase 15 Pro Template anlegen
#
# Verwendung:
#   ./cubase.sh --title "Mein Song" [Optionen]
#
# Optionen:
#   --title       Songtitel (Pflicht)
#   --artist      Interpret (CamelCase → Unterordner)
#   --bpm         Geschwindigkeit
#   --key         Tonart (z.B. "D-Moll", "C-Dur")
#   --template    .cpr-Template (default: default)
#                 Verfügbar: default, mastering, mixing, composition, audio, grainfield
#   --dir         Basis-Pfad überschreiben
#                 Default: /Volumes/PROJECTS/Music/<Artist>/<Song>
#                 Ohne Artist: /Volumes/PROJECTS/Music/<Song>
#   --help        Diese Hilfe
#
# Namenskonvention:
#   - Ordner: CamelCase ohne Leerzeichen (MeinNeuerSong, AnnaBeispiel)
#   - .cpr:    CamelCase ohne Leerzeichen (MeinNeuerSong.cpr)
#
# Verhalten:
#   - Überschreibt NIE bestehende Dateien im Ziel
#   - Legt nur Dateien an, die noch nicht existieren
#   - Kopiert das gewählte .cpr-Template und benennt es nach dem Songtitel
#   - Befüllt metadata.md mit den angegebenen Werten
# ===================================================================

set -euo pipefail

# ─── Pfade ─────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Defaults ──────────────────────────────────────────────────
TEMPLATE_NAME="default"
TARGET_DIR=""
ARTIST=""
BPM=""
KEY=""

# ─── CamelCase-Konvertierung ───────────────────────────────────
to_camelcase() {
    # "Mein neuer Song" → "MeinNeuerSong"
    local input="$(echo "$1" | sed 's/[^a-zA-Z0-9 ]//g')"
    local result="" word upper rest
    for word in $input; do
        upper="$(echo "${word:0:1}" | tr '[:lower:]' '[:upper:]')"
        rest="$(echo "${word:1}" | tr '[:upper:]' '[:lower:]')"
        result="${result}${upper}${rest}"
    done
    echo "$result"
}

# ─── Hilfe ─────────────────────────────────────────────────────
usage() {
    sed -n '/^# Verwendung:/,/^# =*$/p' "$0" | sed 's/^# \?//'
    echo ""
    echo "Verfügbare Templates:"
    if compgen -G "$SCRIPT_DIR/templates/"*.cpr > /dev/null; then
        ls "$SCRIPT_DIR/templates/"*.cpr 2>/dev/null | sed 's|.*/||;s|\.cpr$||' | while read t; do
            echo "  $t"
        done
    else
        echo "  (keine .cpr-Templates vorhanden — .cpr-Dateien in templates/ ablegen)"
    fi
    exit 0
}

# ─── Argumente parsen ──────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --title)    TITLE="$2"; shift 2 ;;
        --artist)   ARTIST="$2"; shift 2 ;;
        --bpm)      BPM="$2"; shift 2 ;;
        --key)      KEY="$2"; shift 2 ;;
        --template) TEMPLATE_NAME="$2"; shift 2 ;;
        --dir)      TARGET_DIR="$2"; shift 2 ;;
        --help)     usage ;;
        *)          echo "Unbekannte Option: $1" >&2; usage ;;
    esac
done

# ─── Validierung ───────────────────────────────────────────────
if [[ -z "${TITLE:-}" ]]; then
    echo "Fehler: --title ist erforderlich." >&2
    usage
fi

TEMPLATE_CPR="$SCRIPT_DIR/templates/${TEMPLATE_NAME}.cpr"

if [[ ! -f "$TEMPLATE_CPR" ]]; then
    echo "Fehler: Template '$TEMPLATE_NAME.cpr' nicht gefunden in templates/" >&2
    echo "Verfügbare Templates:" >&2
    ls "$SCRIPT_DIR/templates/"*.cpr 2>/dev/null | sed 's|.*/||;s|\.cpr$||' | sed 's/^/  /' >&2
    exit 1
fi

# ─── Pfade berechnen ───────────────────────────────────────────
# CamelCase-Namen für Ordner & .cpr-Datei
SAFE_TITLE="$(echo "$TITLE" | sed 's/[^a-zA-Z0-9äöüßÄÖÜ _-]//g; s/  */ /g')"
CC_TITLE="$(to_camelcase "$SAFE_TITLE")"    # MeinNeuerSong

if [[ -n "$TARGET_DIR" ]]; then
    # --dir explizit gesetzt → exakt so verwenden (kein CamelCase-Zwang)
    if [[ -n "$ARTIST" ]]; then
        CC_ARTIST="$(to_camelcase "$ARTIST")"
        SONG_DIR="$TARGET_DIR/$CC_ARTIST/$CC_TITLE"
    else
        SONG_DIR="$TARGET_DIR/$CC_TITLE"
    fi
else
    # Default: /Volumes/PROJECTS/Music/<Artist>/<Song>
    BASE="/Volumes/PROJECTS/Music"
    if [[ -n "$ARTIST" ]]; then
        CC_ARTIST="$(to_camelcase "$ARTIST")"
        SONG_DIR="$BASE/$CC_ARTIST/$CC_TITLE"
    else
        SONG_DIR="$BASE/$CC_TITLE"
    fi
fi

# ─── Ordner anlegen ────────────────────────────────────────────
mkdir -p "$SONG_DIR"

# ─── Helfer: nur kopieren wenn nicht existiert ────────────────
safe_copy() {
    local src="$1" dest="$2"
    if [[ -e "$dest" ]]; then
        echo "  Überspringe (existiert): $(basename "$dest")"
    else
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        echo "  ✓ $(basename "$dest")"
    fi
}

# ─── Nur neue Dateien, keine existierenden überschreiben ───────
copy_dir_safe() {
    local src="$1" dst="$2"
    find "$src" -type f | while read -r f; do
        local rel="${f#$src/}"
        # .gitkeep und .gitignore nicht kopieren
        [[ "$(basename "$rel")" == ".gitkeep" ]] && continue
        [[ "$(basename "$rel")" == ".gitignore" ]] && continue
        safe_copy "$f" "$dst/$rel"
    done
}

echo ""
echo "═══════════════════════════════════════════"
echo "  Song:       $SAFE_TITLE"
[[ -n "$ARTIST" ]] && echo "  Interpret:  $ARTIST"
echo "  Template:   $TEMPLATE_NAME"
echo "  Ziel:       $SONG_DIR"
echo "═══════════════════════════════════════════"
echo ""

# ─── 1. .cpr-Template kopieren ────────────────────────────────
CPR_DEST="$SONG_DIR/${CC_TITLE}.cpr"
safe_copy "$TEMPLATE_CPR" "$CPR_DEST"

# ─── 2. Ordner-Struktur kopieren ──────────────────────────────
echo "Ordnerstruktur …"
copy_dir_safe "$SCRIPT_DIR/_Docs"   "$SONG_DIR/_Docs"
copy_dir_safe "$SCRIPT_DIR/_Sources" "$SONG_DIR/_Sources"
copy_dir_safe "$SCRIPT_DIR/_Refs"   "$SONG_DIR/_Refs"
copy_dir_safe "$SCRIPT_DIR/_Notation" "$SONG_DIR/_Notation"
copy_dir_safe "$SCRIPT_DIR/_Video"  "$SONG_DIR/_Video"
copy_dir_safe "$SCRIPT_DIR/_Artwork" "$SONG_DIR/_Artwork"

# ─── 3. Mixdown-Unterordner ────────────────────────────────────
for sub in Mixes Stems Masters; do
    mkdir -p "$SONG_DIR/Mixdown/$sub"
done

# ─── 4. metadata.md befüllen (nur wenn aus Template kopiert) ──
META="$SONG_DIR/_Docs/metadata.md"
if [[ -f "$META" ]]; then
    TODAY="$(date +%Y-%m-%d)"
    sed -i "s/^# .*/# $SAFE_TITLE/" "$META"
    sed -i "s|{{SONG_TITEL}}|$SAFE_TITLE|g" "$META"
    sed -i "s|{{BPM}}|${BPM:--}|g" "$META"
    sed -i "s|{{KEY}}|${KEY:--}|g" "$META"
    sed -i "s|{{AUFNAHMEDATUM}}|$TODAY|g" "$META"
    [[ -n "$ARTIST" ]] && sed -i "s|{{VOCAL}}|$ARTIST|g" "$META"
    echo "  ✓ metadata.md befüllt"
fi

# ─── 5. versions.md initialisieren ────────────────────────────
VER="$SONG_DIR/_Docs/versions.md"
if [[ -f "$VER" ]]; then
    TODAY="$(date +%Y-%m-%d)"
    sed -i "s|{{SONG_TITEL}}|$SAFE_TITLE|g" "$VER"
    sed -i "s|{{SONG}}|$CC_TITLE|g" "$VER"
    sed -i "s|{{DATUM}}|$TODAY|g" "$VER"
    echo "  ✓ versions.md initialisiert"
fi

# ─── 6. notes.md initialisieren ────────────────────────────────
NOTES="$SONG_DIR/_Docs/notes.md"
if [[ -f "$NOTES" ]]; then
    TODAY="$(date +%Y-%m-%d)"
    sed -i "s|{{INSTRUMENT}}|$SAFE_TITLE|g" "$NOTES"
    sed -i "s|{{DATUM}}|$TODAY|g" "$NOTES"
    echo "  ✓ notes.md initialisiert"
fi

echo ""
echo "✅ Fertig: $SONG_DIR"
echo "   Cubase-Projekt: $CC_TITLE.cpr"
echo "   Nächster Schritt: Cubase öffnen → $SONG_DIR/$CC_TITLE.cpr"
