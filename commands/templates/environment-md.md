# Environment Variables — <project-name>

## Required (app won't start without these)

| Variable | Description |
|----------|-------------|
| `VAR_NAME` | What it's for |

---

## Optional / Defaults

| Variable | Default | Description |
|----------|---------|-------------|
| `VAR_NAME` | `default-value` | What it controls |

---

## .env file

```env
VAR_NAME=value
# OPTIONAL_VAR=value
```

---

## Test environment

Any env setup needed for tests.

---

## Runtime / Internal

Variables set by the app at runtime (not by the user):

| Variable | Set by | Description |
|----------|--------|-------------|
| `VAR_NAME` | Component X | What it signals |
