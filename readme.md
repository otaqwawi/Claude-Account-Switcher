# 🔄 Claude Code Account Switcher

Skrip shell ringan untuk beralih antar akun/profil **Claude Code** secara instan. Dilengkapi dengan sinkronisasi konfigurasi otomatis dan penyimpanan status (*state*) antar sesi terminal.

---

## ✨ Fitur Utama

* 🔄 **Switch Cepat**: Gunakan alias `c1` (Main) & `c2` (Backup) untuk pindah akun dalam satu ketikan.
* 🔄 **One-Way Sync**: Konfigurasi & plugin dari `Main` otomatis disalin ke `Backup` via `rsync`.
* 💾 **State Persistence**: Mengingat profil terakhir yang digunakan bahkan setelah terminal ditutup.
* 🎨 **Prompt Indicator**: Indikator visual pada prompt terminal (`●[Main]` / `●[Backup]`).
* 📦 **Ringan**: Berbasis Pure Bash/Zsh, tanpa dependensi berat.

---

## 📦 Prasyarat

* `bash` atau `zsh`.
* `rsync` terinstall (`sudo apt install rsync` atau `brew install rsync`).
* Claude Code CLI sudah terkonfigurasi minimal satu kali di profil `Main`.

---

## 🛠️ Instalasi

1.  **Buat file skrip terpisah**:
    ```bash
    touch ~/.claude-switcher.sh
    chmod +x ~/.claude-switcher.sh
    ```

2.  **Isi Skrip**:
    Tempelkan seluruh kode skrip Anda ke dalam file `~/.claude-switcher.sh` tersebut.

3.  **Hubungkan ke Shell Config**:
    Tambahkan baris berikut di bagian akhir file `~/.zshrc` atau `~/.bashrc`:
    ```bash
    source ~/.claude-switcher.sh
    ```

4.  **Reload Shell**:
    ```bash
    source ~/.zshrc  # atau source ~/.bashrc
    ```

---

## 🚀 Penggunaan

| Alias | Fungsi |
| :--- | :--- |
| `c1` | Beralih ke akun **Main** |
| `c2` | Beralih ke akun **Backup** (otomatis sinkronisasi config dari Main) |
| `cs` | Cek status akun yang sedang aktif |

**Contoh Output:**
```bash
$ cs
Active: Main account

$ c2
🔄 Syncing config from Main to Backup...
✨ Config synced successfully.
✅ Switched to Backup account

$ cs
Active: Backup account
```

---

## ⚙️ Cara Kerja

| Komponen | Penjelasan |
| :--- | :--- |
| `CLAUDE_CONFIG_DIR` | Variabel lingkungan yang mengarahkan Claude Code ke folder aktif. |
| `~/.claude` | Direktori konfigurasi utama (**Source of Truth**). |
| `~/.claude-backup` | Direktori konfigurasi cadangan (Mirror dari Main). |
| `~/.claude-current-profile` | File status untuk menyimpan profil terakhir yang digunakan. |
| `rsync -a --delete` | Menyalin semua file config Main → Backup & menghapus file usang di Backup. |

> [!IMPORTANT]
> **Alur Sync**: Main → Backup (satu arah). Perubahan yang dilakukan saat berada di profil **Backup** bersifat sementara dan akan tertimpa saat Anda melakukan sinkronisasi ulang dari Main.

---

## ⚠️ Catatan Penting

* **Manajemen Plugin**: Selalu lakukan konfigurasi atau instalasi plugin saat berada di akun **Main**.
* **Prompt Color**: Indikator menggunakan sintaks Zsh (`%F{color}`). Jika Anda menggunakan Bash, sesuaikan variabel `CLAUDE_PROMPT_INFO` menggunakan escape sequence ANSI.
* **Path Kustom**: Jika direktori Claude Code Anda bukan di `~/.claude`, sesuaikan variabel `main_dir` di dalam skrip.

---

## 🛠️ Troubleshooting

| Masalah | Solusi |
| :--- | :--- |
| `rsync: command not found` | Install rsync via package manager (`apt` atau `brew`). |
| Config tidak tersinkron | Pastikan path `main_dir` di skrip sudah mengarah ke folder yang benar. |
| Terminal selalu reset ke Main | Hapus file `~/.claude-current-profile` atau cek apakah ada skrip lain yang menimpa variabel tersebut. |

---

**📝 Lisensi**
MIT License. Bebas digunakan, dimodifikasi, dan didistribusikan.

**💡 Tips Pro**: Gunakan perintah `cs` sebelum memulai sesi panjang untuk memastikan Anda tidak salah menggunakan kuota akun.
