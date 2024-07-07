# xvfb-chrome

A chrome docker image with virtual desktop(xvfb/wayland) support.

Pull the image by

```
docker pull socrateslee/xvfb-chrome
```

The image solve several problems:

- Map chrome `--remote-debugging-port` to host.
- Support run chrome with non-root user chrome(no `--no-sandbox` required to run chrome).
- Support run chrome using virtual desktop with both xvfb and wayland.
- Reduce the occurences of `open /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq: No such file or directory (2)` error.

## Usage

- Start a headless chrome:

```
sudo docker run --rm -it \
                -v $(pwd):/workdir --workdir /workdir \
                --cap-add=SYS_ADMIN \
                socrateslee/xvfb-chrome:latest\
                --headless
```

Note that `--cap-add=SYS_ADMIN` is needed to run chrome with a non-root user.

- Start chrome using xvfb-run and specifiy the `--remote-debugging-port`:

```
sudo docker run --rm -it \
                -v $(pwd):/workdir --workdir /workdir \
                --cap-add=SYS_ADMIN \
                -p 9222:9222 \
                socrateslee/xvfb-chrome:latest\
                --xvfb-run --remote-debugging-port=9222
```

Note that `-p 9222:9222` is for exposing `<DOCKER_CONTAINER_IP>:9222` to host 9222 port. You can always start a cdp connection to `<DOCKER_CONTAINER_IP>:9222` without `-p`.

- Start chorme using wayland:

```
sudo docker run --rm -it \
                -v $(pwd):/workdir --workdir /workdir \
                --cap-add=SYS_ADMIN \
                -p 9222:9222 \
                socrateslee/xvfb-chrome:latest\
                --wayland --remote-debugging-port=9222 --disable-gpu
```

## Entrypoint script options

The entrypoint script support several special options:

- `--xvfb-run`: Start chrome using xvfb-run.
- `--wayland`: Start chrome using wayland. Will add --enable-features=UseOzonePlatform and --ozone-platform=wayland to chrome command line.
- `--remote-debugging-port=<port>`: The option is passed to chrome command line. But the entrypoint script will also fork a socat process to map the port from 127.0.0.1 to 0.0.0.0. So you can always connect to the port from host.

## Note

Some verions of chrome may occur the following error and chrome process will hang:

```
[0707/070947.640825:ERROR:file_io_posix.cc(145)] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq: No such file or directory (2)
[0707/070947.640877:ERROR:file_io_posix.cc(145)] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq: No such file or directory (2)
```

Using `--wayland` option and append `--disable-gpu` can reduce the occurences of the error.