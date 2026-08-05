# GAU-8 Acoustic Simulation

A sound replacement mod for the **GAU-8/A Avenger** in **Arma 3**.

The mod replaces the standard cannon report with a scripted acoustic system designed to give sustained GAU-8 fire more convincing scale, distance, direction, and duration. It preserves the original aircraft, weapons, ammunition, projectiles, impacts, and ballistics.

## Features

- Speed-of-sound propagation delay
- Close, medium, and distant sound layers
- Smooth distance-dependent spectral transitions
- Muzzle directivity
- Approaching and receding Doppler shift
- Terrain and object obstruction
- Ground-interference response
- Environmental decay and diffuse tails
- Dedicated internal cockpit audio
- Sustained-burst start, body, and end behavior
- Native projectile cracks and impact sounds
- AI firing-mode support
- Optional compatibility with RHSUSAF, Firewill, and JSRS Soundmod 2025

## Supported aircraft

| Mod | Aircraft | Weapon |
|---|---|---|
| Arma 3 | A-164 Wipeout | `Gatling_30mm_Plane_CAS_01_F` |
| RHSUSAF | A-10A | `RHS_weap_gau8` |
| Firewill | A-10C Warthog | `FIR_GAU8` |

The base mod does not require RHSUSAF, Firewill, or JSRS. Compatibility components activate only when their corresponding addons are loaded.

## What the mod changes

The mod replaces the audible cannon report for supported GAU-8 weapons.

It does not intentionally modify:

- Rate of fire
- Ammunition capacity
- Damage or penetration
- Muzzle velocity
- Dispersion
- Recoil
- Tracers
- Projectile behavior
- Impact effects
- Aircraft flight models
- Aircraft systems or loadouts

Third-party weapon modes, magazines, ammunition, and impact behavior remain controlled by their original mods.

## Acoustic behavior

External cannon audio is emitted from the weapon's firing position and delayed according to distance using a nominal sound speed of 343 m/s. This means distant observers see the aircraft fire before the main report arrives.

The sound changes with distance:

- Close range emphasizes mechanical detail and a brighter cannon body.
- Medium range transitions toward a heavier and broader report.
- Long range emphasizes the distant body and environmental decay.

The system also accounts for listener angle, source motion, obstruction, and ground interaction. Cockpit listeners receive a separate internal mix without the external free-field delay.

Native Arma or third-party projectile cracks, fly-bys, and impacts are retained.

## Installation

### Steam Workshop

1. Subscribe to the mod.
2. Enable it in the Arma 3 Launcher.
3. Enable any optional supported aircraft or sound mods.
4. Start Arma 3.

Do not load a local development build and the Steam Workshop copy at the same time.

### Manual installation

Place the release folder in the Arma 3 directory or another Launcher-monitored location, then add it through the Arma 3 Launcher.

A normal release contains:

```text
addons/
keys/
mod.cpp
LICENSE
```

Signed PBOs and their matching `.bisign` files are located in `addons/`. The public `.bikey` is located in `keys/`.

## Optional compatibility

<!-- gau8-compat-start -->
### USAF and CUP A-10 Compatibility

| Component | Registered weapon | Required addon |
| --- | --- | --- |
| `gau_gau8_usaf_compat` | Registers `USAF_GAU8_GUN` and suppresses the original USAF A-10C cannon report | `USAF_A10_C` |
| `gau_gau8_cup_compat` | Registers `CUP_Vacannon_GAU8_veh` and suppresses the original CUP GAU-8 cannon report | `CUP_Weapons_VehicleWeapons` |
<!-- gau8-compat-end -->

### RHSUSAF

Supports the RHS A-10A and both GAU-8 firing modes while preserving the original RHS magazines, ammunition, projectiles, and impacts.

### Firewill

Supports the Firewill A-10C and its GAU-8/A Avenger implementation while preserving Firewill loadout and ammunition behavior.

### JSRS Soundmod 2025

An optional compatibility component suppresses overlapping JSRS cannon reports so the scripted GAU-8 sound is not doubled.

Third-party updates may change weapon or sound configuration. Report compatibility regressions with the affected mod versions and loadout.

## Multiplayer

Clients that should hear the replacement acoustic system need the mod loaded.

For servers using signature verification, install the included public key in the server's `keys` directory and distribute the signed release files to clients.

Matching client and server modsets are recommended for predictable behavior.

## Building from source

### Requirements

- Arma 3
- Arma 3 Tools
- HEMTT
- Git
- PowerShell

Clone the repository:

```powershell
git clone https://github.com/Bigg-ie/gau8_acoustics.git
Set-Location .\gau8_acoustics
```

Development build:

```powershell
hemtt check
hemtt dev
```

Release build:

```powershell
hemtt check
hemtt release
```

Use `.hemttout\release` for distribution. Do not distribute `.hemttout\dev`.

## Known limitations

- The acoustic model is a gameplay-oriented approximation, not a full wave-propagation simulation.
- Sound speed is fixed at approximately 343 m/s.
- Obstruction and ground interaction depend on Arma's available world geometry and scripting precision.
- Extremely low or unstable frame rates may reduce timing precision.
- Third-party updates can require compatibility changes.
- The current compatibility list is limited to the supported vanilla, RHSUSAF, Firewill, and JSRS configurations.

## Reporting issues

Include the following when reporting a problem:

- Arma 3 version
- Mod version or commit
- Loaded mod list
- Aircraft and weapon used
- Firing mode
- Whether the problem occurs internally, externally, or both
- Approximate listener distance
- Relevant RPT errors
- Whether another cannon report is audible underneath the replacement

Repository:

https://github.com/Bigg-ie/gau8_acoustics

## Credits and licensing

Arma 3 and Bohemia Interactive names and assets belong to their respective owners.

RHSUSAF, Firewill, and JSRS are third-party projects owned by their respective authors. This project provides optional compatibility and does not claim ownership of those projects.

Only assets with appropriate redistribution rights should be included in public releases.

See the repository's `LICENSE` file for the terms covering this project. Audio assets may have separate restrictions where noted.
