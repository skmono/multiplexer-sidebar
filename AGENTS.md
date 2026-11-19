## Writing

Write in plain, simple language everywhere: code comments, docstrings, docs,
commit messages and explanations to the user. Use complete sentences, and
say what a thing does instead of coining a name for it.

The text in the repo must read as the final, clean version, with no trace of
the back and forth it took to get there. Code, comments and docs describe
only current behavior. Only commit messages and plans may contrast new
behavior with earlier behavior.

## Designing features

The dashboard is one executable file, `multiplexer-dashboard`, that users
drop into a `bin` directory. Keep it that way:

- `multiplexer-sidebar` is a symlink to `multiplexer-dashboard`, so the
  repository has one script under two names. Read and edit only
  `multiplexer-dashboard`. Each release attaches two identical copies of
  the script, one under each name.
- Pushing a `v*` tag runs `.github/workflows/release.yml`, which publishes
  the release and attaches both copies. Make the tag annotated, since its
  message becomes the release notes.
- Standard library only, Python 3.9 or later, and no `curses`.
- Ask each multiplexer for its state through its own CLI, and use its own
  commands for actions. Store nothing on disk; there is no config file.
- `multiplexer-sidebar.tmux` lets tpm install the repository as a tmux
  plugin. It is a POSIX shell script that only binds keys to the script in
  its own directory, so the dashboard itself stays one file. Its key
  options are tmux options, not a config file.
- `prototype/` holds mock prototypes. They are not part of the product and
  are not checked.

## Build and test

Run everything inside the devShell, which provides Python, uv, ruff,
pyrefly, tmux, zellij, herdr and jq:

```sh
nix develop -c make check
```

After changing Python code, including tests, run `make check` and fix any
failures. `make check` runs the unit tests on Python 3.9 and on the current
Python. Any change to terminal handling, key routing or a multiplexer
command must also pass the end-to-end tests:

```sh
nix develop -c make e2e
```

## Plans

Design plans live in `.plans/{active,completed}/<name>/plan.md`, with
progress in `progress.md` next to each plan. Completed plans are history and
may be out of date; the code is current.

## Documentation

- `README.md` is for users: installing, binding a key, and using the
  dashboard. Keep implementation details out of it, such as the icon of
  each agent status or the commands the dashboard runs in each multiplexer.
- Update AGENTS.md (symlinked to CLAUDE.md) for nontrivial decisions and for
  anything the code and scripts cannot explain themselves, such as pitfalls,
  constraints or how to test. Do not restate what the code or its comments
  already say.

# Notes and Rabbit Holes

Knowledge the code does not show. When adding a note, describe the problem
and the outcome to preserve, not a step-by-step patch.

- **Never touch the user's own multiplexers.** You are probably running
  inside one of them, and a kill or rename can reach the user's real
  sessions. Run tests and ad-hoc checks in the isolated environment that
  `scripts/e2e.sh` sets up; a temporary `HOME` alone is not enough.
- **zellij's `focus-pane-id` and `switch-session` move a client only when
  they run in a pane with a client behind it**, such as a pane opened by a
  key binding or a pane of the session's layout. From outside the session,
  or in a pane that `zellij --session S run` opened, they move no client.
  Test zellij switching through a key binding or a layout pane, as
  `scripts/e2e.sh` does. With two clients in a session, only the client
  whose focus is on the dashboard's pane moves.
- **In a zellij layout, `children` inside a split stays empty** in a tab
  with no content of its own, which is every tab that the user opens later.
  The README's sidebar layout uses `new_tab_template` for that reason.
- **Outside the devShell, zellij's welcome screen can break the e2e
  tests.** zellij 0.46 opens a desktop setup screen the first time it runs
  with fresh state, unless its binary is in a package manager's path such
  as `/nix/store`. `scripts/e2e.sh` starts with fresh state on every run,
  so a zellij from a path like `~/.local/bin` covers the tab with that
  screen, and the zellij tab checks fail. Run the e2e tests in the devShell.
- **omp status in tmux comes from its visible pane.** Its working and
  blocked text is part of omp's screen, and can change with omp's interface
  or terminal width. Keep the status check limited to the current pane
  screen and verify it against working, blocked and idle screens when omp
  changes its footer.
- **A tmux sidebar key applies to one window and one server.** Pass the
  source pane and socket from the key binding. A pane option identifies the
  sidebar until that pane closes, including when focus moves elsewhere.
- **A tmux key can run with a different `PATH` from a pane.** Resolve Python
  and tmux when loading the plugin so the toggle can still run from a pane
  whose session environment does not list those commands.
