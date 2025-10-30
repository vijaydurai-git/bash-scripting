search() {
    if [[ "$1" == "--get-default" ]]; then
        current=$(xdg-settings get default-web-browser 2>/dev/null)
        case "$current" in
            google-chrome.desktop) echo "chrome" ;;
            brave-browser.desktop) echo "brave" ;;
            firefox_firefox.desktop) echo "firefox" ;;
            *) echo "unknown: $current" ;;
        esac
        return
    fi

    case "$1" in
        brave)
            desktop_file="brave-browser.desktop"
            cmd="brave-browser"
            ;;
        firefox)
            desktop_file="firefox_firefox.desktop"
            cmd="/snap/bin/firefox"
            ;;
        chrome)
            desktop_file="google-chrome.desktop"
            cmd="google-chrome"
            ;;
        *)
            echo "Usage:"
            echo "  browser [brave|firefox|chrome] [--set-default]"
            echo "  browser --get-default"
            return 1
            ;;
    esac

    if [[ "$2" == "--set-default" ]]; then
        echo "Setting $1 as default browser..."
        xdg-settings set default-web-browser "$desktop_file"
        xdg-mime default "$desktop_file" x-scheme-handler/http
        xdg-mime default "$desktop_file" x-scheme-handler/https
        echo "Default browser set to $1"
    else
        echo "Launching $1..."
        nohup "$cmd" >/dev/null 2>&1 &
    fi
}

