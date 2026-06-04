# Username Tier System

Status: Stable  
Last Reviewed: 2026-06-04

## Scope

Defines fallback rules for TinMan and TinkerSpace usernames/workspace slugs.

Export scope: username ladder guidance is identity-specific and is not part of the default public doctrine snapshot. Keep it in the source doctrine repository or a private/local overlay unless a downstream repository explicitly needs it.

---

## Tier Escalation (TinMan)

Tier 0: tinman
Tier 1: tinmanworks
Tier 2: tinmanlab
Tier 3: tinmanstudio
Tier 4: tinmansystems
Tier 5: tinmanbuild

---

## Tier Escalation (TinkerSpace)

Tier 0: tinkerspace
Tier 1: tinkerspaceworks
Tier 2: tinkerspacelab
Tier 3: tinkerspacestudio
Tier 4: tinkerspacesystems
Tier 5: tinkerspacebuild

---

## Rules

1. Choose identity first by context:
   - TinMan for engineering authorship, developer profiles, and technical communities.
   - TinkerSpace for studio/environment/workspace contexts (for example Linear workspace URLs).
2. Always attempt Tier 0 first.
3. If unavailable, move sequentially.
4. Never skip tiers.
5. Never mix TinMan and TinkerSpace ladders in the same platform scope.
6. Never introduce unlisted suffixes.
7. Avoid numbers unless all listed tiers are unavailable.
8. If numbers are unavoidable, append a two-digit suffix (`01`, `02`, ...) to the last tier only.

---

## Principle

Consistency across platforms is more important than identical usernames everywhere.
