# ArgMap Chrome Extension

Syntax highlighting for `.amap` files opened directly in Chrome via `file://` URLs.

## Install

1. Open `chrome://extensions`
2. Enable **Developer mode** (toggle, top right)
3. Click **Load unpacked** and select this `chrome/` folder
4. On the extension's card, click **Details** → enable **Allow access to file URLs**

## Use

Open any `.amap` file in Chrome (drag into a tab or `File → Open`). The ArgMap Dark palette is applied automatically.

## Palette

| Token | Color |
|-------|-------|
| `[State]` | `#61AFEF` blue bold |
| `↓` `⊗` | `#C678DD` purple |
| `(E)` | `#98C379` green |
| `(T)` | `#56B6C2` teal |
| `(R)` | `#D19A66` orange |
| `(!)` | `#E06C75` red bold |
| `?` stub | `#E06C75` red bold |
| `~` drafted | `#D19A66` orange |
| `*` cited | `#98C379` green |
| `✓` complete | `#98C379` green bold |
| `"note"` | `#5C6370` gray italic |
| `=== TITLE ===` | `#E5C07B` yellow bold |
| `entry:` `exit:` | `#7F848E` gray italic |

## Update

Edit files in this folder, then click the refresh icon on the extension card in `chrome://extensions`.
