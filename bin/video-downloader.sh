#!/usr/bin/env bash
set -euo pipefail

# video-downloader — scarica e trascrive video da YouTube, Udemy, Vimeo, …
# Per altri coding agent: richiede yt-dlp, ffmpeg, python3 e un venv con mlx-whisper/lecture_transcribe.py
#
# Variabili d’ambiente (opzionali):
#   VIDEO_DOWNLOADER_SKILL_DIR — percorso a lecture-transcriber (default: ./skills/lecture-transcriber)
#   VIDEO_DOWNLOADER_PYTHON   — eseguibile python (default: python3)
#   VIDEO_DOWNLOADER_OUTDIR   — cartella output (default: ./downloads)

# --- Configurazione tramite variabili d'ambiente (con default sensati) ---
SKILL_DIR="${VIDEO_DOWNLOADER_SKILL_DIR:-./skills/lecture-transcriber}"
PYTHON="${VIDEO_DOWNLOADER_PYTHON:-python3}"
OUTDIR="${VIDEO_DOWNLOADER_OUTDIR:-./downloads}"

# --- Parse argomenti ---
URL=""
OCR=false
LANG="auto"

usage() {
  echo "Uso: video-downloader \"<URL>\" [--ocr] [--lang it] [--out DIR]"
  echo "  --ocr      Attiva OCR frame ogni 20s (per slide/video didattici)"
  echo "  --lang     Lingua audio (it, en, auto). Default: auto"
  echo "  --out      Cartella output. Default: ./downloads"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ocr) OCR=true; shift ;;
    --lang) LANG="$2"; shift 2 ;;
    --out) OUTDIR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *)
      if [[ -z "$URL" ]]; then URL="$1"; fi
      shift ;;
  esac
done

if [[ -z "$URL" ]]; then
  usage
  exit 1
fi

# --- Directory output ---
mkdir -p "$OUTDIR/trascrizioni"
cd "$OUTDIR"

# --- Platform detection & download ---
echo "🔍 Piattaforma: $URL"

case "$URL" in
  *youtube.com*|*youtu.be*)
    echo "▶️ YouTube rilevato"
    yt-dlp -f "bestaudio[ext=m4a]/bestaudio" -o "%(title)s.%(ext)s" "$URL" --no-warnings
    ;;
  *udemy.com*)
    echo "▶️ Udemy rilevato (richiede cookie)"
    echo "⚠️  Usa 'udemy-dl' con --cookies se disponibile, altrimenti yt-dlp potrebbe fallire"
    yt-dlp -f "bestaudio[ext=m4a]/bestaudio" --remux-video mp4 -o "%(title)s.%(ext)s" "$URL" --no-warnings
    ;;
  *vimeo.com*)
    echo "▶️ Vimeo rilevato"
    yt-dlp -f "bestaudio[ext=m4a]/bestaudio" -o "%(title)s.%(ext)s" "$URL" --no-warnings
    ;;
  *)
    echo "⚠️ Piattaforma non riconosciuta — uso yt-dlp default"
    yt-dlp -f "bestaudio[ext=m4a]/bestaudio" -o "%(title)s.%(ext)s" "$URL" --no-warnings
    ;;
esac

echo "✅ Download completato"

# --- Individuazione file audio ---
AUDIO=$(ls *.m4a *.mp3 2>/dev/null | head -1)
if [[ -z "$AUDIO" ]]; then
  echo "❌ Nessun file audio trovato dopo il download"
  exit 1
fi

TITLE="${AUDIO%.*}"
echo "🎧 Audio: $AUDIO (titolo: $TITLE)"

# --- Trascrizione con lecture_transcribe.py ---
echo "📝 Trascrizione in corso (lingua: $LANG)..."

if [[ "$OCR" == "true" ]]; then
  "$PYTHON" "$SKILL_DIR/lecture_transcribe.py" "$AUDIO" \
    --out "$OUTDIR/trascrizioni" \
    --title "$TITLE" \
    --lang "$LANG"
else
  "$PYTHON" "$SKILL_DIR/lecture_transcribe.py" "$AUDIO" \
    --out "$OUTDIR/trascrizioni" \
    --title "$TITLE" \
    --lang "$LANG" \
    --no-screen
fi

echo "🎉 Trascrizione completata → $OUTDIR/trascrizioni/$TITLE.md"
echo "✅ Fatto! Controlla $OUTDIR/trascrizioni per i risultati"