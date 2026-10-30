SKILL.md — Skill: video-downloader
Ultima modifica: 2026-10-30

1. Scopo
Unifica il download e la trascrizione di video (YouTube, Udemy, Vimeo, …) in un’unica operazione. Riconosce la piattaforma dagli URL, estrae l’audio, lo trascrive con modello locale (`mlx-whisper` tramite `lecture-transcribe.py`) e applica OCR se richiesto. Non inventa contenuti — trascrive fedelmente. Non salva video pesanti nel Knowledge Base.

2. Trigger parole-chiave
- `scarica video YouTube`
- `trascrivi video`
- `download course Udemy`
- `video to transcript`
- `extract audio`
- `/video-downloader`

3. Input
- **`**url**`: string — link YouTube / Udemy / Vimeo / altro
- **`**ocr**`: boolean (opzionale) — OCR frame ogni 20s (default: false)
- **`**lang**`: string (opzionale) — `it`, `en`, `auto` (default: auto)
- **`**out**`: string (opzionale) — cartella output (default: `./downloads`)

4. Output
- `downloads/<title>.m4a` — audio estratto
- `downloads/trascrizioni/<title>.md` — trascrizione con timestamp `[h:mm:ss] parlato`
- `downloads/trascrizioni/<title>_report.md` — report con callout schermo (solo se OCR)

5. Workflow
1. Riconoscimento: regex URL → YouTube / Udemy / Vimeo / altro
2. Download: `yt-dlp -f bestaudio[ext=m4a]/bestaudio` (o `udemy_dl` con cookie se Udemy)
3. Estrazione audio: `ffmpeg -ar 16000 -ac 1` (se necessario)
4. ASR: `lecture_transcribe.py` con `--lang <lang>`
5. OCR (opzionale): `ocr.swift` su frame ogni 20s
6. Fusione: output `.md` e `.json`

6. Compatibilità
- macOS Apple Silicon (MLX Whisper usa Metal)
- `yt-dlp` (`brew install yt-dlp`)
- `ffmpeg` (`brew install ffmpeg`)
- `python` venv `~/.venvs/lecture-transcriber/` (o percorso personalizzato)
- Non serve `sudo`

7. Limitazioni
- Non inventare contenuti — solo trascrizione locale.
- Non duplicare video pesanti nel Knowledge Base.
- Non modificare `.md` originali nel Knowledge Base (Atomic Markdown rule).
- Per Udemy: cookie richiesto (`udemy-dl` con `--cookies`).
- Per audio multi-lingua: se `auto` non riconosce → forzare `--lang`.

8. Esempi d’uso
```bash
# YouTube, solo trascrizione
video-downloader "https://youtu.be/xxxxxxx"

# YouTube con OCR (slide didattiche)
video-downloader "https://youtu.be/xxxxxxx" --ocr

# Udemy con cookie (se disponibile)
video-downloader "https://www.udemy.com/course/xxxxx/" --out ./my-courses --lang en
```

9. Relazioni
- **Dipende da**: `lecture-transcriber` (ASR + OCR), `udemy-dl` (cookie Udemy), `ponytail` (minimal, native prima di dipendenze).
- **Complementare**: `icm-architect` (per audit workspace), `agent-reach` (ricerca riferimenti).
- **Non tocca**: file `.md` originali del Knowledge Base.

10. Relazioni con altre skill
- `udemy-dl` — per cookie Udemy
- `agent-reach` — per ricerca URL
- `llm-researcher` — per verificare contenuti etici
- `opcode` — per integrazione con OpenCode CLI