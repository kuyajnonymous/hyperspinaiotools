# Hyperspin AI Tools

![Alt text](https://github.com/kuyajnonymous/hyperspinaiotools/raw/main/SS.png)

## What's Working?

### 1. **Logo/Wheel Scraping**
- **Source**: StreamGridDB
- **Function**: Scrapes the logo and wheel images and auto-resizes them without any quality loss (avoiding stretching).

### 2. **Video Scraping**
- **Automatic**: Scrape videos using the **YT-DLP** tool by pressing the **Automatic** button.
- **Manual**: Provide the address/URL/location of the video.
  - Downloads the video via **YT-DLP**.
  - Trims the first 5 seconds using **FFmpeg**.

### 3. **Update Button**
When clicked, this button will:
- Check and create the following files if they are missing:
  - **PC Games.ini**: Adds entries if missing.
  - **PC Games.txt**: Adds entries if missing.
  - **CFG Files**: Creates default PC game CFG files (overwrites existing ones).
  - **BAT Files**: Creates default PC game BAT files, overwriting existing ones but ensuring paths are correct for game executables.

---

## Requirments
PowerShell v5+ 
SteamGridApi (Get it from streamgrid website)
YT-DLP (will be downloaded when needed)
FFMPEG (will be downloaded when needed)

## Credits

This script was developed through countless brainstorming sessions and sleepless nights with help from:

- **DeepSeek** (for assistance and ideas)
- **ChatGPT** (for guidance and suggestions)

### Special Mentions:
- **Mytch**: (Perseverance)
- **Shames**: (Better version of me)
- **Kesyia**: (Protector of the Family)
- **Jaime**: (The leader)
