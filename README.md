# takopi-engine-cursor

Cursor Agent CLI engine plugin for [Takopi](https://github.com/RicardoKLee/takopi).

Derived from [FideoJ/takopi](https://github.com/FideoJ/takopi) `feat/cursor-engine`.

## install

```sh
uv pip install "takopi-engine-cursor @ git+https://github.com/RicardoKLee/takopi-engine-cursor.git"
```

or from this checkout:

```sh
uv pip install -e .
```

## usage

```sh
takopi cursor --transport telegram
```

Or prefix messages with `/cursor`. Verify with `takopi plugins --load`.
