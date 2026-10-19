# spectrwm workflow notes

This configuration keeps spectrwm lightweight while carrying over practical workflows from the former bspwm/sxhkd setup.

## Keybindings added for layout and resizing

| Binding | Action |
| --- | --- |
| `Super + -` / `Super + =` | Shrink/grow the master area |
| `Super + Shift + -` / `Super + Shift + =` | Remove/add a stack column or row |
| `Super + Shift + G` | Balance the current layout |
| `Super + Alt + H/J/K/L` | Move a floating window by 20 pixels |
| `Super + Shift + Alt + H/J/K/L` | Shrink/grow a floating window's width or height |

The layout bindings replace bspwm's dynamic gap adjustment with native spectrwm master/stack controls. spectrwm reads `tile_gap` from its configuration; it does not expose a native runtime gap-increment action. The fixed gap remains configured as `tile_gap = 5`.

## Window rules carried over

- Google Chrome opens on workspace 2.
- Opera opens on workspace 3.
- Gimp opens on workspace 5.
- AnyDesk opens on workspace 4.
- mpv and MPlayer float without being forced fullscreen.
- Thunar, Pavucontrol, Galculator, Gpick, feh, and Pinentry float instead of being tiled.

The class/instance patterns should be verified with `xprop WM_CLASS` if an application changes its window class between versions.

## Existing features retained

- Ten workspaces and direct workspace bindings provided by spectrwm.
- Scratchpad helper on `Super + I`, with `Super + Shift + I` to mark/unmark the focused window.
- Directional floating-window movement, focus cycling, swapping, fullscreen, floating toggle, wallpaper controls, touchpad toggle, lock, media, volume, and brightness controls.
- Existing status-bar script and Dunst notification workflow.

## Features that do not map one-to-one

bspwm's tree-based node preselection, parent/brother traversal, and external rule actions do not have direct equivalents in spectrwm's built-in actions. This configuration uses spectrwm's native master/stack layout controls rather than pretending to reproduce bspwm's split tree.
