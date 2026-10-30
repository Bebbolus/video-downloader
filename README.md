# video-downloader

Scarica e trascrivi video da YouTube, Udemy, Vimeo e altre piattaforme usando tool locali (no cloud API).

## Requisiti
- `yt-dlp`
- `ffmpeg`
- Python 3 + venv con `mlx-whisper` e `lecture_transcribe.py` (skill esistente: `6 - OUTPUT/61 - SKILLS/VIDEODOWNLOADER/skills/lecture-transcriber` oppure `~/.venvs/lecture-transcriber`)

## Installazione

1. Clona questo repo:
   ```bash
   git clone https://github.com/tuo-utente/video-downloader.git
   cd video-downloader
   ```

2. Crea e attiva il venv (consigliato):
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install mlx-whisper  # o usa l'installazione di sistema
   ```

3. Rendi eseguibile lo script:
   ```bash
   chmod +x bin/video-downloader.sh
   ```

4. Imposta le variabili d'ambiente (opzionale, oppure modifica i valori di default nello script):
   ```bash
   export VIDEO_DOWNLOADER_SKILL_DIR=/percorso/al/skills/lecture-transcriber
   export VIDEO_DOWNLOADER_PYTHON=python3
   export VIDEO_DOWNLOADER_OUTDIR=/tuo/output/dir
   ```

## Uso

```bash
# YouTube, solo trascrizione
bash bin/video-downloader.sh "https://youtu.be/VIDEO_ID"

# Con OCR slide didattiche
bash bin/video-downloader.sh "https://youtu.be/VIDEO_ID" --ocr

# Lingua forzata + cartella personalizzata
bash bin/video-downloader.sh "https://youtu.be/VIDEO_ID" --lang it --out ./my-trascrizioni
```

## Variabili d’ambiente

| Variabile | Default | Descrizione |
|---|---|---|
| `VIDEO_DOWNLOADER_SKILL_DIR` | `./skills/lecture-transcriber` | Percorso alla directory `lecture-transcriber` (contenente `lecture_transcribe.py`) |
| `VIDEO_DOWNLOADER_PYTHON` | `python3` | Eseguibile Python (può essere `python` o percorso assoluto) |
| `VIDEO_DOWNLOADER_OUTDIR` | `./downloads` | Cartella dove salvare audio + trascrizioni |

## Note di sicurezza

- **Non contiene segreti, cookie, password o dati personali** — i file sono generici e pronti per la pubblicazione su GitHub.
- **Non salva video pesanti** nel KB (`3 - CONOSCENZA/`). Solo audio + trascrizione markdown.
- Per Udemy, i cookie sono responsabilità dell'utente (`udemy-dl` con `--cookies`). Questo script usa `yt-dlp` come fallback.
- Tutti i percorsi sono parametrizzabili via variabili d'ambiente per evitare hardcoding.

## Licenza

MIT — libero di usare, modificare e distribuire.