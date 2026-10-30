# PhotoCraft CLI binaries

This orphan branch holds prebuilt `photocraft-cli` binaries, the headless command-line front end of PhotoCraft. It shares no history with `main`.

| Path | Platform | Version | Built from |
|---|---|---|---|
| `linux-x86_64/photocraft-cli` | Linux x86-64, glibc 2.39 or newer | 0.17.0 (dev build) | `main` @ `249d1266`, rustc 1.97.0, `cargo build --release -p photocraft-cli`, stripped |

The binary links dynamically against only `libc`, `libm` and `libgcc_s`. Check it with `sha256sum -c linux-x86_64/SHA256SUMS`.

These are development builds: they are not signed and are not official releases. For releases, see `docs/releasing.md` on `main`.

## Install

```sh
git clone --branch cli-binaries --single-branch --depth 1 https://github.com/brdmaker/photocraft photocraft-cli
cd photocraft-cli
(cd linux-x86_64 && sha256sum -c SHA256SUMS)
chmod +x linux-x86_64/photocraft-cli
./linux-x86_64/photocraft-cli --version
```

## Subcommands

| Subcommand | What it does |
|---|---|
| `convert IN OUT` | Convert between formats (`.pcraft`, `.psd`, `.png`, `.jpg`, `.tif`, `.webp`, `.exr`, …) |
| `info FILE` | Print the document as JSON: size, mode, depth and layer tree |
| `run` | Open a file or start a new document, run engine commands in order, then save |
| `batch` | Apply an action list to every image in a directory |
| `droplet` | Run a droplet (File › Automate › Create Droplet) on images and folders |
| `commands` | List the engine command registry (`--filter TEXT`, `--json` for the params docs) |
| `mcp` | Run the MCP server on stdio, for AI agents |
| `serve` | Keep one headless session open and answer JSON lines on stdio or on `127.0.0.1:PORT` |

Run `photocraft-cli <subcommand> --help` for every option.

## Examples

```sh
CLI=./linux-x86_64/photocraft-cli

# Convert and inspect
$CLI convert in.psd out.png
$CLI info out.png

# Apply commands to an existing image (one JSON result line per command)
$CLI run in.png --cmd layer.new.layer --params '{"name":"Ink"}' \
                --cmd filter.blur.gaussianBlur --params '{"radius":3}' --out out.psd

# Start from a blank document
$CLI run --new '{"width":800,"height":600}' \
  --cmd filter.render.clouds --params '{"seed":42}' --out clouds.png

# JPEG/WebP quality, layered or compressed TIFF
$CLI run in.png --cmd image.adjustments.invert --out out.jpg --quality 90
$CLI convert in.psd out.tif --tiff-layers --tiff-compression zip

# Batch: play an action over a folder (refuses --out == --in unless --in-place)
$CLI batch --actions actions.json --in photos/ --out done/ --format jpg

# Find commands and their parameters
$CLI commands --filter blur
$CLI commands --json > commands.json
```

`actions.json` holds the steps of an action, for example `[{"command": "filter.blur.gaussianBlur", "params": {"radius": 2}}]`. It can also be `[["<id>", {…}], …]`, a list of bare ids, or an Actions panel set (use `--action <name>` to pick one action from the set).

Every user action in PhotoCraft is an engine command, so anything you can do from a menu you can also run here by command id. `commands --json` lists each command's `params` schema.

## Sample

`examples/sample-scene.sh` draws `examples/sample.png` from a blank canvas using a gradient, shape layers, layer styles, the Tree render filter and a type layer:

```sh
sh examples/sample-scene.sh ./linux-x86_64/photocraft-cli /tmp
```

![Sample](examples/sample.png)

## MCP (agents)

```sh
# Headless engine. Without a root flag, that direction of file access is denied.
photocraft-cli mcp --automation-read-root /abs/in --automation-write-root /abs/out

# Bridge to a running desktop app started with --control 7878 --control-token-file <path>
photocraft-cli mcp --bridge 127.0.0.1:7878 --control-token-file <path>
```

The full documentation lives on `main`: `docs/development.md` › Headless CLI, and `docs/control-protocol.md`.
