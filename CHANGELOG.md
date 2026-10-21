# Changelog

## Unreleased

- Extended the external close-body perspective so the close bank remains dominant through danger-close ranges; the close-to-medium transition now completes around 1.25 km and the medium-to-far transition spans roughly 1.5–3 km.
- Removed the dedicated recorded cannon-release tail from the default burst path. Existing long grains now finish naturally.
- Added a guaranteed environment-only terminal decay derived from the last sustain state, preserving the final report's distance mix, position, motion, and propagation context without replaying another dry cannon grain.
- Added distance-dependent spectral softening for the direct supersonic projectile crack so distant cracks no longer retain an unnaturally close transient.
- Calibrated approaching report Doppler while retaining full receding behavior and a bounded source-pitch ceiling.
- Centralized vehicle listener-space handling into shared interior/exterior state. Exterior projectile-crack layers are now excluded from the source aircraft cockpit at their actual arrival time.
- Added A-10-tastic compatibility: its engine and airframe presentation remains active, its GAU-8 SoundSets are suppressed, and its 1-second, 2-second, and 3-second cannon modes are accepted by the scripted acoustic system.
- Retained the V27.34 single-close-bank experiment as a runtime A/B option, but restored close/medium/far report banks as the default architecture.

## 1.2.0 — 2026-09-14

- Replaced the short phase-overlap cannon sustain with the continuous long-grain report architecture.
- Restored moving-source distance updates, physical propagation delay, obstruction, ground response, and environmental tails.
- Set the stationary report reference to 65 Hz and use source-referenced asymmetric Doppler with the approach constrained near the original source pitch.
- Set the report attack and direct masters to `5.0`.
- Set the supersonic projectile crack output master to `0.40`.
- Removed development-only comments and stale source backup scripts.
- Updated repository documentation and HEMTT metadata for the 1.2.0 release.
