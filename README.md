# multiplexer-sidebar

A herdr-style sidebar and a fullscreen dashboard for
[tmux](https://github.com/tmux/tmux) and [zellij](https://zellij.dev), and
for [herdr](https://herdr.dev) itself. Both show every session and every
coding agent (claude, codex, opencode, pi, omp, gemini and others) in one place.
Press Enter to jump there.

- Keep the sidebar open in a narrow pane beside your work, as in herdr, to
  see at a glance which agent is working and which one is waiting for you.
- Press a key inside tmux, zellij or herdr to open the fullscreen dashboard
  in a floating pane, with a live preview of each session and agent. Pick
  one and land on it.
- Run `multiplexer-sidebar` in a shell with no multiplexer attached, such
  as right after you SSH into a machine, to see the sessions of every installed multiplexer and
  attach to one.
- Create, rename and kill sessions without remembering each multiplexer's
  commands.

It is a standalone Python script with no dependencies (only used stdlib). You
can copy it to any machine, including a remote server you SSH into, and run it
right away, with nothing to install or compile. Even so, it looks and feels
like a modern terminal app built with a framework such as
[Ratatui](https://ratatui.rs) or [Bubble
Tea](https://github.com/charmbracelet/bubbletea), with gradient colors, rounded
borders, themes that match your terminal's dark or light background, and smooth
keyboard navigation.

## Showcase

### Dashboard across tmux, Zellij, and herdr

Run the dashboard from a shell outside any multiplexer to browse sessions
and agents across all three. Press Enter to jump to the selected session
or agent.

![Dark dashboard outside a multiplexer](assets/outside-dark.png)

### Dashboard inside Zellij

Open the dashboard in a floating pane to browse Zellij sessions, see which
agents are working or waiting for you, and preview the selected session or
agent.

![Dark dashboard in a Zellij popup](assets/zellij-dark-popup.png)

### Full-width sidebar

Keep a herdr-style sidebar open in a pane beside your work in Zellij or
tmux. It shows session and agent names, along with any reported agent
status.

![Dark full-width sidebar in Zellij](assets/zellij-dark-sidebar.png)

### Compact sidebar

Use a three-column strip beside your work when screen space is tight. It
shows numbered sessions and agents, with status indicators when available.

![Dark compact sidebar in Zellij](assets/zellij-dark-compact.png)

<details name="showcase-variants">
<summary>Zellij · Light</summary>

**Dashboard across tmux, Zellij, and herdr**

![Light dashboard outside a multiplexer](assets/outside-light.png)

**Dashboard inside Zellij**

![Light dashboard in a Zellij popup](assets/zellij-light-popup.png)

**Full-width sidebar**

![Light full-width sidebar in Zellij](assets/zellij-light-sidebar.png)

**Compact sidebar**

![Light compact sidebar in Zellij](assets/zellij-light-compact.png)

</details>

<details name="showcase-variants">
<summary>tmux · Dark</summary>

**Dashboard across tmux, Zellij, and herdr**

![Dark dashboard outside a multiplexer](assets/outside-dark.png)

**Dashboard inside tmux**

Browse tmux sessions and agents in a floating pane with a live preview.

![Dark dashboard in a tmux popup](assets/tmux-dark-popup.png)

**Full-width sidebar**

![Dark full-width sidebar in tmux](assets/tmux-dark-sidebar.png)

**Compact sidebar**

![Dark compact sidebar in tmux](assets/tmux-dark-compact.png)

</details>

<details name="showcase-variants">
<summary>tmux · Light</summary>

**Dashboard across tmux, Zellij, and herdr**

![Light dashboard outside a multiplexer](assets/outside-light.png)

**Dashboard inside tmux**

Browse tmux sessions and agents in a floating pane with a live preview.

![Light dashboard in a tmux popup](assets/tmux-light-popup.png)

**Full-width sidebar**

![Light full-width sidebar in tmux](assets/tmux-light-sidebar.png)

**Compact sidebar**

![Light compact sidebar in tmux](assets/tmux-light-compact.png)

</details>

## Why

The best part of herdr is its sidebar: it shows your workspaces and your
agents, so you always know which agent is working, which one is waiting for
you, and where it lives.

herdr now puts its effort into its desktop and mobile apps, which are built on
herdr-core and do not work with the herdr TUI. The TUI is likely to be
gradually abandoned, the way Arc was. I do not want my favorite feature to die
with it.

<details>
<summary>Why Arc is the right comparison, and why not fork the TUI</summary>

The herdr TUI and herdr-core are separate programs. In
[herdr's FAQ](https://herdr.dev/), herdr says: "They don't share agents, so
what runs in one doesn't show up in the other." About the TUI's future, the
FAQ says only that "Herdr TUI keeps working." It does not say whether the TUI
will get new features or fixes, or for how long.

Arc went the same way. The Browser Company stopped adding features to Arc in
May 2025 to work on its next browser, Dia, and kept Arc working. In October
2026 it
[announced](https://techcrunch.com/2026/10/22/arc-browser-sunsets-december-22-as-the-browser-company-doubles-down-on-dia/)
that Arc stops working on December 22, 2026.

The herdr TUI is open source, so anyone can fork it, and with a coding agent
anyone can keep changing the fork. The code is the easy part. A project also
lives on its community and ecosystem. When upstream moves on to its next
product, they split. Some users move to the herdr app, and many who dislike
the move are left without a home. It is hard to bring them back together under
a fork, and the community around it would be small and fragile. tmux and zellij already have a large, settled
community and ecosystem, so the dashboard builds on them instead.

</details>

The apps also mean lock-in at both ends: the machine you work on must
run the herdr-core server, and the device you work from must run
herdr's desktop or mobile app. A classic TUI has no lock-in. It works
in any terminal, over any SSH client, from a laptop or a phone, and
the server needs nothing but a shell and the multiplexer.

So this dashboard brings the sidebar to tmux and zellij, which have worked
this way for years and are not going anywhere. herdr is supported too,
since the dashboard already speaks to the other two.

## Install

It is one file that needs Python 3.9 or later and nothing else:

```sh
curl -L -o ~/.local/bin/multiplexer-sidebar \
  https://github.com/milanglacier/multiplexer-sidebar/releases/latest/download/multiplexer-sidebar
chmod +x ~/.local/bin/multiplexer-sidebar
```

`multiplexer-dashboard` is an alias of `multiplexer-sidebar`. Each release
has a file under each name, and the two files are identical. Key bindings
that run `multiplexer-dashboard` keep working if you download that file
instead.

### With tpm

For tmux alone, you can install it with the
[tmux plugin manager](https://github.com/tmux-plugins/tpm) instead. Add
this line to `~/.tmux.conf` and press `prefix` + `I`:

```tmux
set -g @plugin 'skmono/multiplexer-sidebar'
```

The plugin binds these keys, so you can skip the tmux steps below:

- `prefix` + `Tab` opens the dashboard in a floating pane, or in a popup
  before tmux 3.8.
- `prefix` + `b` opens or closes the sidebar on the left of the current window.

To pick other keys, set these options before the `@plugin` line. An empty
value binds no key.

```tmux
set -g @multiplexer-sidebar-key 'Tab'          # the dashboard
set -g @multiplexer-sidebar-sidebar-key 'b'    # the sidebar
set -g @multiplexer-sidebar-compact-key ''     # the compact sidebar, unbound
```

The plugin does not put `multiplexer-sidebar` on your `PATH`. To run it
from a shell or from zellij, install the file as shown above.

## Set up a key binding

Bind a key to open the dashboard in a floating pane. Give the pane enough
room: below about 72 columns the preview is hidden.

tmux 3.8 (`~/.tmux.conf`):

```tmux
bind tab new-pane -O -x80% -y80% -X10% -Y10% -c '#{pane_current_path}' multiplexer-sidebar
```

zellij (`~/.config/zellij/config.kdl`):

```kdl
bind "Tab" {
    Run "multiplexer-sidebar" {
        floating true
        close_on_exit true
        width "80%"
        height "80%"
        x "10%"
        y "10%"
    };
    SwitchToMode "Normal"
}
```

herdr:

```toml
[[keys.command]]
key = "prefix+alt+d"
type = "popup"
command = "multiplexer-sidebar"
width = 140
height = 40
```

## Keep it open in a sidebar

`multiplexer-sidebar --sidebar` shows only the Sessions and Agents lists,
so it fits a narrow pane of about 30 columns. It stays open after you
switch: Enter takes you to the session or agent, Escape goes back to the
pane you came from, and `q` quits.

tmux (`~/.tmux.conf`), to open a sidebar on the left of the current window:

```tmux
set -g focus-events on
bind b run-shell "multiplexer-sidebar --tmux-toggle-sidebar '#{pane_id}' '#{socket_path}'"
```

Press `prefix+b` to open or close the sidebar in the current window.

zellij (`~/.config/zellij/layouts/default.kdl`), to give every tab a
sidebar, including the tabs and sessions you open later:

```kdl
layout {
    new_tab_template {
        pane size=1 borderless=true {
            plugin location="tab-bar"
        }
        pane split_direction="vertical" {
            pane size=32 command="multiplexer-sidebar" close_on_exit=true {
                args "--sidebar"
            }
            pane focus=true
        }
        pane size=2 borderless=true {
            plugin location="status-bar"
        }
    }
}
```

When zellij brings back an exited session, press Enter in the sidebar to
start it again.

### A compact sidebar for small screens

On a laptop screen or a terminal split in half, a 30-column sidebar takes
too much room. `--compact` shrinks it to a strip 3 columns wide, with a
number and a status for each session and agent, so you can still see at a
glance which session needs you. Move and press Enter to switch, as in the
full sidebar.

tmux (`~/.tmux.conf`):

```tmux
set -g focus-events on
bind b run-shell "multiplexer-sidebar --tmux-toggle-sidebar '#{pane_id}' '#{socket_path}' --compact"
```

zellij (`~/.config/zellij/layouts/compact-sidebar.kdl`), as a layout of its
own, so that your default layout keeps its full sidebar or none. The
sidebar pane is 5 columns wide, which leaves room for zellij's pane border
and the 3-column compact sidebar.

```kdl
layout {
    new_tab_template {
        pane size=1 borderless=true {
            plugin location="tab-bar"
        }
        pane split_direction="vertical" {
            pane size=5 command="multiplexer-sidebar" close_on_exit=true {
                args "--compact"
            }
            pane focus=true
        }
        pane size=2 borderless=true {
            plugin location="status-bar"
        }
    }
}
```

Start a session with this layout when you want the compact sidebar:

```sh
zellij --layout compact-sidebar
```

To filter, or to create, rename or kill a session, use the full dashboard.

If you want both, use `--sidebar` and resize the pane with your
multiplexer's keys: below 24 columns the sidebar turns compact, and when
the pane is wide enough again it shows the full sidebar.

## Keys

| Key             | Action                                 |
| --------------- | -------------------------------------- |
| `j` `k` `↑` `↓` | move                                   |
| `Alt+j` `Alt+k` | next / previous multiplexer            |
| `h` `l` `←` `→` | hide / show the session's tabs         |
| `H` `L`         | hide / show the tabs of every session  |
| `Tab`           | switch between sessions and agents     |
| `Enter`         | go to the session, tab or agent        |
| `/`             | filter as you type                     |
| `n` `r` `x`     | new / rename / kill session            |
| `?`             | show every key                         |
| `q` `Escape`    | close                                  |

A session's tabs (tmux windows, zellij tabs or herdr tabs) show indented
under it, and the filter also matches their names. The mouse works too:
click to select, click again to go there, and scroll to move.

<details>
<summary>Options and details</summary>

```
multiplexer-sidebar [--multiplexer tmux|zellij|herdr] [--client CLIENT]
                    [--dir DIR] [--theme auto|light|dark] [--no-bg]
                    [--sidebar] [--compact] [--tabs collapsed|expanded]
```

- `--multiplexer` lists only one multiplexer.
- `--client` is the tmux client to switch, for a binding that opens the
  dashboard on behalf of another client.
- `--dir` is the directory of new sessions. It defaults to the current
  directory, and inside herdr to the current pane's directory.
- `--theme` picks Rose Pine (dark) or Rose Pine Dawn (light). By default the
  dashboard follows the terminal's background color.
- `--no-bg` keeps the terminal's own background.
- `--sidebar` shows only the lists, and inside a multiplexer stays open
  after a switch. See [Keep it open in a sidebar](#keep-it-open-in-a-sidebar).
  herdr has a sidebar of its own, and in herdr Escape does nothing.
- `--compact` shows the sidebar as a narrow strip of numbers and statuses.
  It implies `--sidebar`.
- `--tabs expanded` starts with the tabs of every session shown. The
  default, `--tabs collapsed`, starts with them hidden. Either way, `h`,
  `l`, `H` and `L` change it.

Inside a multiplexer the dashboard lists only that multiplexer, or each one
it runs in when they are nested. herdr workspaces appear as sessions, and
herdr agents show herdr's own status: working, idle, blocked or done. With
zellij 0.46 or later, an agent that reports its status to zellij shows it
too, and can also show error. In tmux, omp shows whether it is working,
waiting for input or idle.

A new session with an empty name is named after the git repository or the
directory it starts in. If a session with that name exists, the dashboard
switches to it instead.

Each agent has its own icon. To detect more agent programs, list their
names. These agents share the icon `◇`:

```sh
export MULTIPLEXER_DASHBOARD_AGENTS=kimi,myagent
```

</details>

## Development

```sh
nix develop -c make check   # format, lint, type check and unit tests
nix develop -c make e2e     # end-to-end tests in isolated tmux, zellij and herdr sessions
```

## License

[GPL-3.0](LICENSE)
