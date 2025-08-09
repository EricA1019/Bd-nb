# Contributing

Branching & PRs
- Create feature/* branches; open PRs to main; ensure CI is green.

Tests
- Add/adjust GUT tests alongside code. Run locally headless as CI does.

Pre-push Hook
- Enable local tests before push: `make install-hooks`.

Releases
- End each hop with a version tag v0.<phase>.<hop>; update CHANGELOG and docs.
