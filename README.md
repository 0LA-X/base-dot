# Dotfile Setup

> Automated Arch Linux setup — installs packages, dotfiles, themes, and configures your environment from scratch.

---

## What Does This Do?

Running `setup.sh` will automatically:

1. Check your system and internet connection
2. Update your Arch Linux packages
3. Download the dotfiles from GitHub
4. Install `yay` (an AUR package helper)
5. Install all packages (terminal tools, Hyprland, fonts, media tools, etc.)
6. Link the dotfiles to your home folder using `stow`
7. Run helper scripts to set up audio, Zsh, TMUX, and boot themes

---

## Before You Start

Make sure you have the following:

- A fresh **Arch Linux** install (this won't work on Ubuntu, Fedora, etc.)
- An active **internet connection**
- A **non-root user account** with `sudo` access — do not run this as root

> **Not sure if you have sudo?** Open a terminal and type `sudo whoami`. If it prints `root`, you're good.

---

## Step-by-Step Instructions

### 1. Open a Terminal

Press `Ctrl + Alt + T` or search for "Terminal" in your launcher.

---

### 2. Install Git (if you don't have it)

```bash
sudo pacman -S git
```

---

### 3. Clone This Repository

```bash
git clone https://github.com/0LA-X/base-dot.git ~/base-dot
```

This downloads all the setup files into a folder called `base-dot` in your home directory.

---

### 4. Navigate Into the Folder

```bash
cd ~/base-dot
```

---

### 5. Make the Script Executable

```bash
chmod +x setup.sh
```

This gives the script permission to run.

---

### 6. Run the Setup Script

```bash
bash setup.sh
```

> The script will ask for your `sudo` password at certain steps. This is normal — it needs admin rights to install packages.

---

### 7. Wait for It to Finish

The setup can take **10–30 minutes** depending on your internet speed. You'll see progress messages in the terminal as each step completes.

A log file is saved automatically at:

```
~/.local/state/setup.log
```

If anything goes wrong, open that file to see exactly what happened.

---

### 8. Reboot

Once the script finishes, reboot your system to apply all changes:

```bash
reboot
```

---

## What Gets Installed

| Category | Packages |
|---|---|
| Dev Tools | `gcc`, `clang`, `python`, `nodejs`, `rustup`, `git` |
| Terminal | `kitty`, `zsh`, `tmux`, `nvim`, `eza`, `fzf` |
| Hyprland | `hyprland`, `hypridle`, `hyprlock`, `waybar` |
| Media | `ffmpeg`, `mpv`, `imagemagick`, `playerctl` |
| File Tools | `yazi`, `nautilus`, `7zip`, `unzip` |
| Fonts | Cascadia Code Nerd Font, Noto Emoji |
| Themes | GRUB theme, Plymouth boot splash |
| Audio | PipeWire, WirePlumber, Bluetooth tools |
| Gaming *(optional)* | Steam, Lutris, Wine, Vulkan, MangoHud |

---

## Helper Scripts

These run automatically as part of `setup.sh`, but you can also run them individually if needed:

| Script | What it does |
|---|---|
| `Scripts/_helpers/setup_audio.sh` | Installs PipeWire, enables Bluetooth |
| `Scripts/_helpers/setup_zsh.sh` | Installs Zsh and sets it as your default shell |
| `Scripts/_helpers/tpm.sh` | Sets up TMUX Plugin Manager |
| `Scripts/_helpers/setup_boot_themes.sh` | Installs Plymouth splash + GRUB theme |
| `Scripts/_helpers/setup_game.sh` | Installs gaming tools (run manually if needed) |
| `Scripts/_helpers/spicetify.sh` | Installs Spotify + Spicetify theming |

To run one individually:

```bash
bash ~/base-dot/Scripts/_helpers/setup_audio.sh
```

---

## Something Went Wrong?

**Check the log file first:**

```bash
cat ~/.local/state/setup.log
```

**Common issues:**

| Problem | Fix |
|---|---|
| `pacman not found` | This script only works on Arch Linux |
| `No internet connection` | Check your network with `ping archlinux.org` |
| `yay install failed` | Make sure `base-devel` is installed: `sudo pacman -S base-devel` |
| `stow failed for Config` | A conflicting dotfile may already exist — back it up and re-run |
| `multilib not enabled` | Open `/etc/pacman.conf`, uncomment `[multilib]` and the line below it |

**Re-running the script is safe.** Most steps check if something is already done and skip it automatically.

---

## Enabling Multilib (for Gaming)

The gaming setup requires 32-bit libraries. To enable multilib:

```bash
sudo nano /etc/pacman.conf
```

Find these two lines and remove the `#` at the start of each:

```
#[multilib]
#Include = /etc/pacman.d/mirrorlist
```

Save with `Ctrl + O`, exit with `Ctrl + X`, then run:

```bash
sudo pacman -Sy
```

---

## Need Help?

- Log file: `~/.local/state/setup.log`
- Arch Wiki: [wiki.archlinux.org](https://wiki.archlinux.org)
- Open an issue on the repo if something is consistently broken
