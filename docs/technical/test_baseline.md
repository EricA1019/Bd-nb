# Test Baseline

Date: 2025-08-09
Hop: 5 (Housekeeping A) — In Progress

Summary
- Total tests: 19
- Passing: 19
- Failing: 0
- Warnings: 0

Notes
- DB migration logs demoted to info; version logged once at boot.
- SaveService JSON int comparisons normalized in tests.
- Ascii grid integration test frees instantiated scene to avoid orphans.

Next
- Prune scratch tests if any appear during Hop 6.
- Consider extracting DB query helper and parameterized queries.
