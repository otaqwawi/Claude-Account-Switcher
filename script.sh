# --- Claude Code Account Switcher (Main -> Backup Sync) ---

function claude-switch() {
    local profile=$1
    # Sesuaikan path ini jika config default Claude Code Anda berbeda
    local main_dir="$HOME/.claude" 
    local backup_dir="$HOME/.claude-backup"
    local status_file="$HOME/.claude-current-profile"

    # Pastikan direktori ada
    mkdir -p "$main_dir"
    mkdir -p "$backup_dir"

    if [[ "$profile" == "main" ]]; then
        unset CLAUDE_CONFIG_DIR
        export CLAUDE_PROMPT_INFO="%F{yellow}●[Main]%f"
        echo "✅ Switched to Main account"
        echo "main" > "$status_file"

    elif [[ "$profile" == "backup" ]]; then
        # --- SYNC PROCESS ---
        # Salin konfigurasi dari Main ke Backup agar plugin & setting sama
        # -a: archive mode (preserve permissions, links, etc)
        # -v: verbose (opsional, bisa dihapus jika ingin silent)
        # --delete: hapus file di backup yang tidak ada di main (clean mirror)
        
        echo "🔄 Syncing config from Main to Backup..."
        rsync -a --delete "$main_dir/" "$backup_dir/" 2>/dev/null
        
        if [[ $? -eq 0 ]]; then
            echo "✨ Config synced successfully."
        else
            echo "⚠️ Warning: rsync failed or not installed. Config might be outdated."
        fi
        # ------------------

        export CLAUDE_CONFIG_DIR="$backup_dir"
        export CLAUDE_PROMPT_INFO="%F{magenta}●[Backup]%f"
        echo "✅ Switched to Backup account"
        echo "backup" > "$status_file"
    else
        echo "Usage: claude-switch [main|backup]"
        return 1
    fi
}

function claude-status() {
    if [[ -z "$CLAUDE_CONFIG_DIR" ]]; then
        echo "Active: Main account"
    else
        echo "Active: Backup account"
    fi
}

alias c1="claude-switch main"
alias c2="claude-switch backup"
alias cs="claude-status"

# --- Auto-restore last used profile on terminal start ---
STATUS_FILE="$HOME/.claude-current-profile"
if [[ -f "$STATUS_FILE" ]]; then
    last_profile=$(cat "$STATUS_FILE")
    # Saat restore, kita juga perlu sync jika terakhir kali menggunakan backup
    # Agar config backup tetap up-to-date dengan main sebelum dipakai
    if [[ "$last_profile" == "backup" ]]; then
        claude-switch backup > /dev/null
    else
        claude-switch main > /dev/null
    fi
else
    claude-switch main > /dev/null
fi
# --- End Claude Code Switcher ---
