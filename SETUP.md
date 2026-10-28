# Setting up a new mod from this template

This template captures the administrative/repo layer that's shared across
`kam_compat_zen`, `civilian_presence_extended`, `Camo_Faces_Redux`,
`tactical-tarps`, and `clear-hud-rewrite`: CI, branch protection, funding,
contributor docs, editor config, and the Steam Workshop description
convention. It also ships a minimal, dependency-free
`addons/main` so a fresh clone actually builds (`hemtt check` / `hemtt build`
both pass out of the box) — it's intentionally not a full CBA/ACE-integrated
skeleton. If your mod depends on CBA_A3, swap `addons/main/script_mod.hpp`'s
minimal macro block for CBA's real `script_macros_common.hpp` (see
[DartsArmaMods/ModTemplate](https://github.com/DartsArmaMods/ModTemplate) for
what that looks like). `hemtt new` only scaffolds a whole new project, not a
single addon within an existing one — copy `addons/main` as a starting point for each new
component instead.

## 1. Create the repo

Click "Use this template" on GitHub, or:

```
gh repo create Andx667/<new-repo> --template Andx667/arma-mod-template --public --clone
```

## 2. Find-and-replace placeholders

Four distinct tokens, deliberately not sharing text with any real macro name
(`MOD_NAME`/`PREFIX` are actual CBA/HEMTT macro names used in the addon code,
so the placeholder values below avoid colliding with them):

| Placeholder | Meaning | Where |
|---|---|---|
| `MOD_TITLE` | Human display name, e.g. `KAM Compat ZEN` | `README.md`, `mod.cpp`, `.hemtt/project.toml`, `workshop/steam_description.md`, `addons/main/script_mod.hpp` (`#define MOD_NAME MOD_TITLE`), `.github/workflows/discord-notice.yml` (`username`/`footer_title`) |
| `MOD_REPO` | GitHub repo slug (URL-safe), e.g. `kam_compat_zen` | GitHub URLs in `README.md`/`mod.cpp`/`workshop/steam_description.md`, `.github/workflows/release-drafter.yml`'s `if:`, `.github/PULL_REQUEST_TEMPLATE.md`'s Development Guidelines link, `MOD_REPO.code-workspace` (filename too) |
| `MOD_PREFIX` | HEMTT prefix / code namespace, e.g. `kcz` — lowercase, matches every addon's `#define COMPONENT` | `.hemtt/project.toml` (`prefix`), `addons/main/$PBOPREFIX$`, `addons/main/script_mod.hpp` (`#define PREFIX MOD_PREFIX`), `addons/main/stringtable.xml`, `.github/workflows/release.yml` (`releases/MOD_PREFIX-latest.zip`, twice), `tools/stringtable_validator.py` (`PROJECT_NAME`) |
| `MOD_ABBR` | Short abbreviation, e.g. `KCZ` | `README.md`, `workshop/steam_description.md` |

Also:

| Placeholder | Where | Replace with |
|---|---|---|
| Workshop ID (`0`) | `README.md` badges, `meta.cpp` (`publishedid`), `workshop/steam_description.md` | The Steam Workshop item ID once the mod is published there |
| `discord.gg/ag4v6kxYAa` | `README.md`, `workshop/steam_description.md` | Already the shared invite all of Andx667's mods use — leave as-is unless this mod needs a different Discord |
| Dependencies line | `README.md`, `.github/release-drafter.yml`'s `template:` | Actual required addons, or the "no hard dependencies" wording if there are none |

## 3. Apply branch protection

Template repos don't carry rulesets over. Once the repo exists, apply the
same ruleset the other three repos share — block deletion/force-push,
require the `check` and `validate` status checks, 0 required approvals,
repo-admin bypass:

```bash
gh api --method POST -H "Accept: application/vnd.github+json" \
  repos/Andx667/<new-repo>/rulesets --input - <<'JSON'
{
  "name": "default",
  "target": "branch",
  "enforcement": "active",
  "conditions": {"ref_name": {"exclude": [], "include": ["~DEFAULT_BRANCH"]}},
  "rules": [
    {"type": "deletion"},
    {"type": "non_fast_forward"},
    {"type": "pull_request", "parameters": {"required_approving_review_count": 0, "dismiss_stale_reviews_on_push": false, "required_reviewers": [], "require_code_owner_review": false, "require_last_push_approval": false, "required_review_thread_resolution": false, "require_extra_approval_for_unattributed_changes": true, "allowed_merge_methods": ["merge", "squash", "rebase"]}},
    {"type": "required_status_checks", "parameters": {"strict_required_status_checks_policy": true, "do_not_enforce_on_create": true, "required_status_checks": [{"context": "check", "integration_id": 15368}, {"context": "validate", "integration_id": 15368}]}}
  ],
  "bypass_actors": [{"actor_id": 5, "actor_type": "RepositoryRole", "bypass_mode": "always"}]
}
JSON
```

## 4. Create the release-drafter labels

Template repos don't carry labels over either. `.github/release-drafter.yml`
categorizes PRs into the drafted release notes by label — none of these
exist on a freshly-created repo:

```bash
REPO=Andx667/<new-repo>
gh label create "changelog/added" -R "$REPO" --color "0E8A16" --description "New feature or capability" --force
gh label create "changelog/changed" -R "$REPO" --color "1D76DB" --description "Change in existing functionality" --force
gh label create "changelog/deprecated" -R "$REPO" --color "FBCA04" --description "Soon-to-be removed feature" --force
gh label create "changelog/removed" -R "$REPO" --color "B60205" --description "Removed feature" --force
gh label create "changelog/fixed" -R "$REPO" --color "5319E7" --description "Bug fix" --force
gh label create "changelog/security" -R "$REPO" --color "D93F0B" --description "Security fix" --force
gh label create "ignore-changelog" -R "$REPO" --color "EDEDED" --description "Excluded from the drafted release changelog" --force
gh label create "tools" -R "$REPO" --color "EDEDED" --description "Repo tooling/admin change, excluded from the changelog" --force
```

These six category names (`added`/`changed`/`deprecated`/`removed`/`fixed`/
`security`) are deliberately the same as `CHANGELOG.md`'s Keep a Changelog
categories — label a PR, and the drafted release note and the CHANGELOG.md
entry you write for it use the same vocabulary.

(An earlier version of this template also had a `target/next-arma` label
driving a `version-resolver` that auto-computed the next major/minor/patch
from PR labels. Dropped — see below for why.)

## 5. Keep CHANGELOG.md current — it's the source of truth, not release-drafter

Versioning here is deliberately manual: **`addons/main/script_version.hpp`
and the git tag you create at release time are the source of truth**, not
anything release-drafter or PR labels compute. Release Drafter still drafts
a release on every push to `main`, grouping merged PRs by the labels above
into a "### Added" / "### Changed" / etc. skeleton (matching
`CHANGELOG.md`'s categories exactly) — but its draft is always titled
generic `Unreleased`, not a version number, and picking the *actual* next
version (and whether it's a major/minor/patch bump) is a judgment call you
make by hand.

When you're ready to cut a release:

1. Bump `MAJOR`/`MINOR`/`PATCH` in `addons/main/script_version.hpp` yourself
2. In `CHANGELOG.md`, rename `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD`
   matching that version, and start a fresh empty `## [Unreleased]` above it
3. Retitle the drafted GitHub release from "Unreleased" to `vX.Y.Z` and set
   its tag to match, then publish it — `release.yml` (CI) picks up from
   there, builds, and attaches the zip

This template ships `CHANGELOG.md` (Keep a Changelog format) and a
`workshop/steam_description.md` already wired into `.hemtt/project.toml`'s
`[hemtt.publish]` section. Once your Steam Workshop item exists (`meta.cpp`
has a real `publishedid`), running `hemtt publish` locally (Steam must be
running and logged in — it uses the desktop client, not a username/password
secret) builds the mod, converts both Markdown files to Steam Workshop
BBCode, and uploads — no more hand-maintained BBCode, and no CI secrets to
manage for it.

`hemtt publish`'s changelog step specifically looks up the entry whose
heading *exactly* matches the current project version — so step 2 above
has to happen before you run it, or it fails with "No changelog entry
found for version X.Y.Z".

Add an entry under `## [Unreleased]` for every user-facing change as you
make it — don't leave it to write itself at release time.

## 6. Wire up the Discord release notice

`.github/workflows/discord-notice.yml` posts to Discord whenever a GitHub
release is published, via
[SethCohen/github-releases-to-discord](https://github.com/SethCohen/github-releases-to-discord).
It reads the webhook URL from a repo secret rather than a committed file —
never hardcode a webhook URL in the workflow, it's a bearer credential
anyone with repo-read access could post through:

```bash
gh secret set DISCORD_WEBHOOK_URL --repo Andx667/<new-repo> --body "<your Discord webhook URL>"
```

All of Andx667's mods currently share one webhook/channel for release
notices — ask for that URL rather than creating a new one, unless this mod
needs its own channel.

## 7. Everything else

- Add real `img/icon.png` / `img/icon_ca.paa` (referenced by `mod.cpp` and the README)
- Fill in `workshop/` with real screenshots once you have them
- Set repo topics (at minimum: `arma3`) and the repo description/homepage to the Steam Workshop URL once published
