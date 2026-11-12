# openrun-counter

A minimal OpenRun app: a page with a count and a + button. The count is stored
through OpenRun's built-in `store.in` plugin (SQLite by default).

App files are at the repository root (`app.star`, `schema.star`, `index.go.html`).
OpenRun does not need a subfolder when `app.star` is at the root.

## Run locally

```sh
openrun server start
openrun app create --approve --auth none ./ /counter
# then open http://localhost:25222/counter
```

## Deploy to control.grin.land

After this repo is pushed to GitHub:

```sh
export OPENRUN_SERVER_URI=https://control.grin.land
export OPENRUN_API_KEY=orun_pat_...   # or: openrun login --server https://control.grin.land

openrun app create --approve --auth none github.com/grinland/openrun-counter /counter
```

The app is then served at https://control.grin.land/counter. Later updates:

```sh
openrun app reload --approve --promote github.com/grinland/openrun-counter /counter
```

`--approve` is required for the `store.in` plugin permissions. `--auth none`
leaves the counter itself public. The API key (or logged-in user) must be
allowed to create apps and must include the literal `app:approve` permission
(it is not covered by a `*` scope).
