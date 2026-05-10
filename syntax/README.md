# ArgMap syntax highlighting

Syntax definitions for `.amap` files.

| File | Target |
|------|--------|
| `argmap.vim` | Vim — syntax rules |
| `argmap-ftdetect.vim` | Vim — filetype detection |
| `argmap.sublime-syntax` | bat / Sublime Text — syntax grammar |
| `argmap-dark.tmTheme` | bat — colour theme |
| `argmap-theme-spec.yml` | Theme spec (source, not installed) |

---

## Vim

Copy both vim files into your vim config:

```bash
cp argmap.vim ~/.vim/syntax/argmap.vim
cp argmap-ftdetect.vim ~/.vim/ftdetect/argmap.vim
```

Any file ending in `.amap` will activate the `argmap` filetype automatically. To apply manually in an open buffer:

```
:set ft=argmap
```

---

## bat

`bat` uses Sublime Text syntax files (`.sublime-syntax`) and tmTheme colour themes.

**1. Find your bat config directory:**

```bash
bat --config-dir
```

**2. Copy the syntax and theme:**

```bash
cp argmap.sublime-syntax "$(bat --config-dir)/syntaxes/"
cp argmap-dark.tmTheme   "$(bat --config-dir)/themes/"
```

**3. Rebuild the cache:**

```bash
bat cache --build
```

**4. Use it:**

```bash
bat --language argmap --theme "ArgMap Dark" yourfile.amap
```

To make these the defaults for `.amap` files, add to `$(bat --config-dir)/config`:

```
--map-syntax "*.amap:argmap"
--theme="ArgMap Dark"
```
