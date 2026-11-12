load("store.in", "store")

COUNTER_NAME = "main"


def _load():
    ret = store.select(table.counter, {"name": COUNTER_NAME}, limit=1)
    if not ret:
        return None
    rows = []
    for row in ret.value:
        rows.append(row)
    if rows:
        return rows[0]
    return None


def current_count():
    row = _load()
    if row:
        return row.value
    return 0


def get_counter(req):
    return {"count": current_count()}


def increment(req):
    store.begin()
    row = _load()
    if row:
        row.value = row.value + 1
        store.update(table.counter, row)
        count = row.value
    else:
        store.insert(table.counter, doc.counter(name=COUNTER_NAME, value=1))
        count = 1
    store.commit()
    if req.IsPartial:
        return {"count": count}
    return ace.redirect(req.AppPath)


app = ace.app("Counter",
              custom_layout=True,
              routes=[
                  ace.html("/", "index.go.html", handler=get_counter,
                           fragments=[
                               ace.fragment("increment", partial="count",
                                            method="POST", handler=increment),
                           ]),
              ],
              permissions=[
                  ace.permission("store.in", "select"),
                  ace.permission("store.in", "insert"),
                  ace.permission("store.in", "update"),
                  ace.permission("store.in", "begin"),
                  ace.permission("store.in", "commit"),
              ],
              )
