# Fix: Rust linker can't find libiconv (and other system libs) on macOS
# when Xcode/CLT SDKs are the only source of .tbd files
# Set SDKROOT so the linker knows which SDK to search
# Set LIBRARY_PATH so cc finds .tbd files in the SDK's usr/lib
if [[ "$(uname)" == "Darwin" ]]; then
    export SDKROOT="${SDKROOT:-$(xcrun --show-sdk-path 2>/dev/null)}"
    if [[ -n "$SDKROOT" && -d "$SDKROOT/usr/lib" ]]; then
        case ":$LIBRARY_PATH:" in
            *":$SDKROOT/usr/lib:"*) ;;
            *) export LIBRARY_PATH="$SDKROOT/usr/lib${LIBRARY_PATH:+:$LIBRARY_PATH}" ;;
        esac
    fi
fi
