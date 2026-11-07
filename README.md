<h1 align="center">Astrify CLI</h1>
<p align="center">
  <strong>Command-line tool to customize the official Spotify client.</strong><br>
  Developed by <strong>Varq</strong> • Community Discord: <a href="http://discord.gg/astria">discord.gg/astria</a><br>
  Supports Windows, macOS, and Linux. Compatible with existing Spicetify extensions and themes.
</p>

---

### Features

- 🎨 **Change colors** across the Spotify user interface
- 💅 **Inject CSS** for advanced customization
- 🧩 **Inject Extensions** to add features, tweak UI, and control playback
- 📱 **Inject Custom Apps** seamlessly into Spotify's navigation
- 🛑 **No unwanted auto-updates** — automatic update checks and prompts are completely disabled
- 🔄 **Full compatibility** with both Astrify and Spicetify ecosystem themes & extensions
- ⚡ **Take complete control** of your Spotify desktop experience

---

### Basic Usage

```sh
# Backup original Spotify assets
astrify backup

# Apply customizations, themes, and extensions
astrify apply

# Or apply automatically in one command
astrify auto

# Inspect or edit config
astrify config

# Change theme colors
astrify color
```

---

### JavaScript Runtime API

Astrify exposes both `window.Astrify` and `window.Spicetify` in Spotify's runtime environment, ensuring 100% backward compatibility with all community extensions while providing a modern namespace for Astrify customizations.

---

### Credits & Community

- **Developer**: Varq
- **Discord Server**: [http://discord.gg/astria](http://discord.gg/astria)
- Built upon the open-source foundation of the Spicetify project.
