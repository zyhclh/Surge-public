# Public Mirror Sync

Use `scripts/sync-public.sh` from this private repository to publish a filtered copy to a separate public repository.

The sync excludes these private files:

- `.github/workflows/`
- `Conf/Spec/Surge-zyhclh.conf`
- `Conf/Spec/Surge.conf`
- `Conf/Spec/mihomo.yaml`

## Usage

Create a new empty public repository on GitHub, then run:

```bash
scripts/sync-public.sh git@github.com:zyhclh/Surge-public.git
```

Optional settings:

```bash
PUBLIC_WORKTREE=../Surge-public \
PUBLIC_BRANCH=main \
COMMIT_MESSAGE="Sync public mirror" \
scripts/sync-public.sh git@github.com:zyhclh/Surge-public.git
```

The script keeps a local checkout of the public repository, copies the private repository into it with `rsync --delete`, removes the excluded files from the public checkout, commits any changes, and pushes to the public repository.
