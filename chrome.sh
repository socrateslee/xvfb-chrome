#!/bin/bash                                                                                                                                                                                                                                                                                                                                         socat_port=""
other_args=()
command="/opt/google/chrome/google-chrome" 
remote_debugging_port=""
wayland=""

for arg in "$@"; do
    case "$arg" in
    --xvfb-run)
        command="/usr/bin/xvfb-run /opt/google/chrome/google-chrome"
        ;;
    --wayland)
        other_args+=(--enable-features=UseOzonePlatform)
        other_args+=(--ozone-platform=wayland)
        export XDG_RUNTIME_DIR=/tmp
        export WAYLAND_DISPLAY=wayland-1
        /usr/bin/weston --backend=headless-backend.so &
        ;;
    --remote-debugging-port=*)
        remote_debugging_port="${arg#*=}"
        other_args+=("$arg")
        ;;
    *)
        other_args+=("$arg")
        ;;
    esac
    shift
done

if [[ -n "$remote_debugging_port" ]]; then
    bind=$(ifconfig eth0 | grep "inet\b" | awk '{print $2}')
    echo socat TCP4-LISTEN:$remote_debugging_port,bind=$bind,reuseaddr,fork TCP4:127.0.0.1:$remote_debugging_port
    socat TCP4-LISTEN:$remote_debugging_port,bind=$bind,reuseaddr,fork TCP4:127.0.0.1:$remote_debugging_port &
fi

echo $command "${other_args[@]}"
$command "${other_args[@]}"
