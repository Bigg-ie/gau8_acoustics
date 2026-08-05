# GAU-8 Acoustic Simulation

A physically informed GAU-8/A Avenger sound replacement for **Arma 3**.

The mod replaces the normal cannon report with a scripted, distance-aware acoustic system designed to make sustained GAU-8 fire behave like a large airborne rotary cannon rather than a single looping weapon sample. It models propagation delay, distance-dependent spectral changes, directivity, Doppler shift, obstruction, ground interaction, environmental decay, and dedicated cockpit sound while preserving the original aircraft, weapon, ammunition, projectile, impact, and ballistic behavior.

> **Project status:** Pre-release / release candidate  
> **Repository:** https://github.com/Bigg-ie/gau8_acoustics  
> **Current HEMTT project version:** `0.1.0`  
> **Current internal milestone:** `gau8-v11.1-gau-namespace`

---

## Contents

- [What the mod changes](#what-the-mod-changes)
- [What the mod does not change](#what-the-mod-does-not-change)
- [Supported aircraft and weapons](#supported-aircraft-and-weapons)
- [Optional compatibility](#optional-compatibility)
- [Acoustic system](#acoustic-system)
- [Installation](#installation)
- [Recommended load combinations](#recommended-load-combinations)
- [Multiplayer and server use](#multiplayer-and-server-use)
- [Building from source](#building-from-source)
- [Project structure](#project-structure)
- [Runtime architecture](#runtime-architecture)
- [Adding support for another weapon](#adding-support-for-another-weapon)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Publishing](#publishing)
- [Known limitations](#known-limitations)
- [Version history](#version-history)
- [Credits, source material, and licensing](#credits-source-material-and-licensing)

---

## What the mod changes

The mod replaces the audible cannon report for supported GAU-8 weapons with a scripted acoustic presentation.

The replacement system includes:

- Start, sustained-grain, and end phases
- Close, medium, and distant spectral layers
- Speed-of-sound propagation delay
- Distance-dependent crossover between sound layers
- Muzzle directivity
- Listener-relative Doppler shift
- Arrival-time obstruction testing
- Ground-interference filtering
- Environmental and diffuse decay tails
- Dedicated internal cockpit sound
- Deterministic sustained-burst timing
- AI-compatible firing-mode handling
- Optional suppression of third-party and JSRS cannon reports
- Native Arma projectile cracks and impact sounds

The mod is intended to improve the **perceived scale, distance, direction, and duration** of GAU-8 fire without replacing the underlying weapon simulation.

## What the mod does not change

The mod does **not** intentionally alter:

- Ammunition classes
- Magazine capacities
- Projectile muzzle velocity
- Projectile damage
- Penetration
- Dispersion
- Rate of fire
- Weapon recoil
- Aircraft flight models
- Aircraft systems
- Muzzle flashes
- Tracers
- Projectile fly-by cracks
- Impact effects
- Impact sounds
- Third-party aircraft loadout systems

For RHSUSAF and Firewill aircraft, the original weapon inheritance, modes, magazines, and ammunition are preserved.

---

## Supported aircraft and weapons

### Vanilla Arma 3

| Aircraft | Weapon | Supported modes |
|---|---|---|
| A-164 Wipeout | `Gatling_30mm_Plane_CAS_01_F` | `LowROF`, `close`, `short`, `medium`, `far` |

### RHSUSAF

| Aircraft | Weapon | Supported modes |
|---|---|---|
| A-10A (`RHS_A10`) | `RHS_weap_gau8` | `LowROF`, `HighROF`, `close`, `short`, `medium`, `far` |

Preserved RHS magazines:

- `rhs_mag_1150Rnd_30x173`
- `rhs_mag_1150Rnd_30x173_mixed`
- `rhs_mag_1000Rnd_30x173`
- `rhs_mag_1000Rnd_30x173_mixed`

Preserved RHS ammunition includes:

- `rhs_ammo_PGU14B_API`
- `rhs_ammo_30x173mm_GAU8_mixed`

### Firewill

| Aircraft | Weapon | Supported mode handling |
|---|---|---|
| A-10C Warthog (`FIR_A10C`) | `FIR_GAU8` | Wildcard registration; the Fired event reports `FIR_GAU8` as the active mode |

Preserved Firewill magazines:

- `FIR_GAU8_1174rnd_M`
- `1174Rnd_GAU8_30mm_Plane_CAS_01_F`

Preserved Firewill ammunition includes:

- `FIR_GAU8_CM_ammo`

---

## Optional compatibility

The base mod does not require RHSUSAF, Firewill, or JSRS.

Compatibility addons use `skipWhenMissingDependencies = 1`, so they are ignored when their required third-party mod is absent.

| Compatibility addon | Purpose | Required third-party addon |
|---|---|---|
| `gau_gau8_firewill_compat` | Registers `FIR_GAU8` and suppresses the original Firewill cannon report | `FIR_AirWeaponSystem_US` |
| `gau_gau8_rhsusaf_compat` | Registers `RHS_weap_gau8` and suppresses its original LowROF/HighROF report | `rhsusf_c_heavyweapons` |
| `gau_gau8_jsrs2025_compat` | Suppresses the JSRS report applied to the vanilla GAU-8 | JSRS 2025 configuration addon |
| `gau_gau8_rhsusaf_jsrs2025_compat` | Suppresses the JSRS 2025 RHS HighROF report after the RHS JSRS patch loads | `jsrs2025_compat_rhs_usf` |

### JSRS Soundmod 2025

The compatibility work was developed against:

- JSRS Soundmod 2025
- Version observed during development: `4.0.0.12`
- Steam Workshop item observed during development: `3407948300`

Third-party class names and patch structure can change. Revalidate compatibility after major JSRS, RHSUSAF, or Firewill updates.

---

## Acoustic system

### 1. Event-driven replacement

The mod listens for supported weapon firing events on aircraft. When a supported weapon and mode are detected, it starts or extends a scripted burst state.

The original cannon report is suppressed through compatibility configuration. The scripted system then presents the replacement sound locally to each listener.

The acoustic system is not implemented as a projectile SoundSet replacement. Native projectile cracks and impacts remain available.

### 2. Historical emission position

The source position is captured at the projectile or muzzle emission point rather than continuously following the aircraft for the entire propagation delay.

This prevents a fast-moving aircraft from dragging an already-emitted cannon report through space before it reaches the listener.

### 3. Speed-of-sound delay

External cannon audio is delayed according to source-to-listener distance using a nominal sound speed of:

```text
343 m/s
```

The delay is evaluated before playback so distant observers see the aircraft fire before the main report arrives.

Cockpit audio does not use the same free-field delay because the listener is inside the firing aircraft.

### 4. Start, sustain, and end architecture

A burst is divided into three phases:

1. **Start** — initial spin-up and onset character
2. **Sustain** — scheduled grains that form the continuous cannon body
3. **End** — release and decay after the firing state stops

The accepted recording set uses dedicated start assets, six sustained grains, and end assets. Grain scheduling avoids a single obvious looping sample and allows burst length to follow actual firing duration.

### 5. Distance spectra

The current distance model uses close, medium, and far bodies.

| Distance | Blend behavior |
|---:|---|
| `0–150 m` | Close body |
| `150–500 m` | Close to medium, constant-sum crossover |
| `500–800 m` | Medium to far, equal-power crossover |
| `800 m+` | Far body |

This arrangement keeps near fire bright and mechanically detailed while allowing distant fire to become broader, heavier, and less transient-dominated.

### 6. Current spectral and gain tuning

The accepted tuning includes:

- Brightened close-body treatment
- Crackle removal from the brightened close sample
- Presence-focused equalization
- Denser sustained grains
- Diffuse environmental tails
- Far-body gain increase of approximately `+15 dB`
- Far-body linear trim of approximately `5.623413`
- Raised internal gain clamp of `8.0`

These values are implementation tuning, not real-world sound-pressure measurements.

### 7. Directivity

The system applies listener-angle-dependent gain to represent stronger forward muzzle radiation.

Current front-to-rear differences:

| Layer | Front/rear difference |
|---|---:|
| Close body | `4.44 dB` |
| Medium body | `2.89 dB` |
| Far body | `1.17 dB` |
| Mechanical layer | `0 dB` |
| Muzzle component | `17.5 dB` |

The result is a stronger and sharper presentation ahead of the muzzle, with increasingly diffuse radiation at long range.

### 8. Doppler shift

The system applies a listener-relative pitch adjustment based on source and listener motion.

The implementation uses the actual `playSound3D` pitch argument. This gives approaching and receding passes a more convincing shift without changing projectile physics.

### 9. Obstruction

Obstruction is evaluated at acoustic arrival time rather than only at the moment of firing.

This allows the calculation to better reflect the geometry present when the delayed report reaches the listener.

Obstruction processing is intended to reduce and darken sound through terrain or solid geometry. It is not a full diffraction or wave-propagation solver.

### 10. Ground interference

The mod uses a single-voice ground-interference treatment rather than a separate discrete reflection voice.

This reduces obvious echo duplication while retaining distance- and geometry-dependent tonal interaction between the direct path and the ground-influenced path.

### 11. Environmental tails

Environmental decay is presented with diffuse tails rather than a single hard reflection.

The tails are designed to add scale and space without turning every burst into an obvious repeated echo.

### 12. Cockpit presentation

When the listener is inside the firing aircraft and using an internal or gunner camera, the mod switches to a dedicated internal presentation.

Cockpit behavior includes:

- `playSoundUI`-based internal playback
- No free-field propagation delay
- Dedicated cockpit cannon body
- Airframe/mechanical contribution
- Deterministic shot-clock handling
- Sustained timing based on alternating 20- and 22-shot scheduling blocks

The internal mix is intentionally different from the external free-field report.

### 13. Burst timing

The firing scheduler uses:

- `diag_tickTime`
- `uiSleep`
- Deterministic burst-state timing
- Tail completion without force-stopping active sounds

This avoids frame-time dependence from the normal simulation clock and permits already-started tail sounds to finish naturally.

### 14. Native projectile acoustics

The mod intentionally retains native Arma or third-party:

- Supersonic cracks
- Fly-by behavior
- Projectile impacts
- Material-specific impact effects

Only the supported weapon’s cannon report is replaced.

---

## Installation

### Steam Workshop

After publication:

1. Subscribe to the mod.
2. Enable it in the Arma 3 Launcher.
3. Enable any desired optional aircraft or sound mods.
4. Start Arma 3.
5. Confirm the mod appears in the Expansions menu.

Do not load a local HEMTT development build at the same time as the subscribed Workshop copy.

### Manual installation

A release package should have a structure similar to:

```text
@GAU-8 Acoustic Simulation/
├── addons/
│   ├── gau_gau8_main.pbo
│   ├── gau_gau8_main.pbo.<authority>.bisign
│   ├── gau_gau8_firewill_compat.pbo
│   ├── gau_gau8_rhsusaf_compat.pbo
│   ├── gau_gau8_jsrs2025_compat.pbo
│   ├── gau_gau8_rhsusaf_jsrs2025_compat.pbo
│   └── matching .bisign files
├── keys/
│   └── <authority>.bikey
├── mod.cpp
└── LICENSE
```

Place the mod folder in the Arma 3 directory or another Launcher-monitored directory, then add it through the Launcher.

---

## Recommended load combinations

### Vanilla only

```text
Arma 3
GAU-8 Acoustic Simulation
```

### Vanilla with JSRS

```text
Arma 3
JSRS Soundmod 2025
GAU-8 Acoustic Simulation
```

### RHSUSAF

```text
Arma 3
CBA_A3, when required by RHS
RHSUSAF and its required RHS components
GAU-8 Acoustic Simulation
```

### Firewill

```text
Arma 3
Firewill A-10 / FIR AWS dependencies
GAU-8 Acoustic Simulation
```

### RHSUSAF with JSRS

```text
Arma 3
RHSUSAF and required RHS components
JSRS Soundmod 2025
JSRS RHS compatibility
GAU-8 Acoustic Simulation
```

Arma resolves addon dependencies using `requiredAddons[]`. The Launcher order is less important than ensuring all required third-party addons are loaded and no duplicate local/Workshop copy is active.

---

## Multiplayer and server use

All clients that should hear the replacement acoustic system need the mod loaded.

For servers using signature verification:

1. Build a signed HEMTT release.
2. Distribute the mod PBOs and `.bisign` files to clients.
3. Install the included `.bikey` in the server’s `keys` directory.
4. Add the mod to the server and client launch parameters as appropriate.

The mod is primarily an acoustic client-side system, but matching modsets are recommended for predictable multiplayer behavior.

Do not assume that a local `.hemttout/dev` symlink represents the same files as a Workshop installation. Test the actual published package separately.

---

## Building from source

### Requirements

- Windows
- Arma 3
- Arma 3 Tools
- HEMTT
- Git
- PowerShell

Run Arma 3 Tools at least once after installation so its registry configuration is initialized.

### Clone

```powershell
git clone https://github.com/Bigg-ie/gau8_acoustics.git
Set-Location .\gau8_acoustics
```

### Development build

```powershell
hemtt check
hemtt dev
```

The development build creates a link similar to:

```text
<Arma 3>\z\gau
```

The PBO prefix namespace is:

```text
z\gau\addons\...
```

### Clean development build

```powershell
Remove-Item .\.hemttout `
    -Recurse -Force -ErrorAction SilentlyContinue

hemtt check
hemtt dev
```

### Release build

```powershell
hemtt check
hemtt release
```

Inspect:

```text
.hemttout\release
releases\
```

The release build should be used for Workshop or server distribution, not `.hemttout\dev`.

---

## Project structure

```text
gau8_acoustics/
├── .hemtt/
│   └── project.toml
├── addons/
│   ├── main/
│   │   ├── $PBOPREFIX$
│   │   ├── config.cpp
│   │   ├── functions/
│   │   │   ├── fn_clientInit.sqf
│   │   │   ├── fn_getAcousticState.sqf
│   │   │   ├── fn_getEnvironmentState.sqf
│   │   │   ├── fn_installGrainHandler.sqf
│   │   │   ├── fn_queueSoundArrival.sqf
│   │   │   └── fn_registerWeapon.sqf
│   │   └── sounds/
│   │       └── cannon/
│   ├── firewill_compat/
│   │   ├── $PBOPREFIX$
│   │   ├── config.cpp
│   │   └── functions/fn_preInit.sqf
│   ├── rhsusaf_compat/
│   │   ├── $PBOPREFIX$
│   │   ├── config.cpp
│   │   └── functions/fn_preInit.sqf
│   ├── jsrs2025_compat/
│   │   ├── $PBOPREFIX$
│   │   └── config.cpp
│   └── rhsusaf_jsrs2025_compat/
│       ├── $PBOPREFIX$
│       └── config.cpp
├── sources/
├── tests/
├── tools/
├── mod.cpp
└── README.md
```

Some local development directories, test packages, and backups may not be part of the public repository.

---

## Runtime architecture

### Namespace

The current personal/project namespace is:

```text
gau
```

Primary patch and function namespace:

```text
gau_gau8_*
```

Old `big_gau8_*` and `z\big` references were removed before public release.

### Main patch

```text
gau_gau8_main
```

### Compatibility patches

```text
gau_gau8_firewill_compat
gau_gau8_rhsusaf_compat
gau_gau8_jsrs2025_compat
gau_gau8_rhsusaf_jsrs2025_compat
```

### Weapon registry

Supported weapons are registered in:

```sqf
missionNamespace getVariable ["gau_gau8_weaponRegistry", []]
```

The registry allows the main Fired-event logic to remain generic rather than hard-coding only the vanilla weapon.

### Handler installation

The client initialization code:

- Scans existing aircraft
- Checks pilot/driver weapon slots
- Checks driver turret `[-1]`
- Checks all turrets
- Installs the handler on supported `Air` objects
- Handles aircraft created after mission start
- Avoids duplicate handler installation
- Stores the handler identifier on the aircraft

The aircraft handler variable is:

```sqf
gau_gau8_firedHandler
```

### Primary functions

The current function namespace is:

```text
gau_gau8_fnc_*
```

Important functions include:

| Function | Purpose |
|---|---|
| `gau_gau8_fnc_clientInit` | Finds supported aircraft and installs handlers |
| `gau_gau8_fnc_installGrainHandler` | Installs or refreshes the aircraft Fired handler |
| `gau_gau8_fnc_registerWeapon` | Adds a weapon and its accepted modes to the registry |
| `gau_gau8_fnc_getAcousticState` | Calculates listener/source acoustic state |
| `gau_gau8_fnc_getEnvironmentState` | Calculates obstruction and environmental state |
| `gau_gau8_fnc_queueSoundArrival` | Schedules delayed external playback |

---

## Adding support for another weapon

A third-party compatibility addon can register another weapon during `preInit`.

### Explicit modes

```sqf
[
    "MY_GAU8_WEAPON",
    [
        "LowROF",
        "HighROF"
    ]
] call gau_gau8_fnc_registerWeapon;
```

### Wildcard mode

Use wildcard mode when the Fired event reports a nonstandard or weapon-named mode:

```sqf
[
    "MY_GAU8_WEAPON",
    ["*"]
] call gau_gau8_fnc_registerWeapon;
```

A complete compatibility addon normally needs to:

1. Require `gau_gau8_main`.
2. Require the third-party weapon’s defining addon.
3. Set `skipWhenMissingDependencies = 1`.
4. Register the weapon in `preInit`.
5. Suppress only the original cannon report.
6. Preserve the exact original weapon inheritance chain.
7. Preserve magazines, ammunition, modes, and non-audio properties.
8. Add a separate late-loading patch if another sound mod overwrites the weapon after the normal compatibility patch.

### Critical inheritance rule

Do not reopen a third-party weapon as an unparented class:

```cpp
class MY_GAU8_WEAPON
{
};
```

That can erase inherited `scope`, modes, magazines, and other properties.

Preserve the original parent:

```cpp
class MY_GAU8_WEAPON: ORIGINAL_PARENT
{
};
```

Nested fire-mode classes must also preserve their original inheritance where required.

---

## Testing

### Basic configuration checks

In the Eden debug console:

```sqf
private _result =
[
    [
        "new patch",
        isClass
        (
            configFile
            >> "CfgPatches"
            >> "gau_gau8_main"
        )
    ],
    [
        "old patch",
        isClass
        (
            configFile
            >> "CfgPatches"
            >> "big_gau8_main"
        )
    ],
    [
        "new function",
        !(isNil "gau_gau8_fnc_installGrainHandler")
    ],
    [
        "old function",
        !(isNil "big_gau8_fnc_installGrainHandler")
    ]
];

copyToClipboard str _result;
hint str _result;
```

Expected:

```text
new patch: true
old patch: false
new function: true
old function: false
```

### Third-party weapon configuration

```sqf
private _result =
[
    [
        "RHS scope",
        getNumber
        (
            configFile
            >> "CfgWeapons"
            >> "RHS_weap_gau8"
            >> "scope"
        )
    ],
    [
        "RHS modes",
        getArray
        (
            configFile
            >> "CfgWeapons"
            >> "RHS_weap_gau8"
            >> "modes"
        )
    ],
    [
        "RHS magazines",
        getArray
        (
            configFile
            >> "CfgWeapons"
            >> "RHS_weap_gau8"
            >> "magazines"
        )
    ],
    [
        "Firewill scope",
        getNumber
        (
            configFile
            >> "CfgWeapons"
            >> "FIR_GAU8"
            >> "scope"
        )
    ],
    [
        "Firewill modes",
        getArray
        (
            configFile
            >> "CfgWeapons"
            >> "FIR_GAU8"
            >> "modes"
        )
    ],
    [
        "Firewill magazines",
        getArray
        (
            configFile
            >> "CfgWeapons"
            >> "FIR_GAU8"
            >> "magazines"
        )
    ]
];

copyToClipboard str _result;
hint str _result;
```

Expected essentials:

- RHS scope is nonzero
- Firewill scope is nonzero
- RHS modes include `LowROF` and `HighROF`
- Firewill modes include `this`
- Original magazine arrays remain present

### Aircraft weapon presence

With test aircraft named `gau8_test_plane_rhs` and `gau8_test_plane_fir`:

```sqf
private _result =
[
    [
        "RHS weapons",
        gau8_test_plane_rhs weaponsTurret [-1]
    ],
    [
        "Firewill weapons",
        gau8_test_plane_fir weaponsTurret [-1]
    ]
];

copyToClipboard str _result;
hint str _result;
```

Expected entries:

```text
RHS_weap_gau8
FIR_GAU8
```

### Sustained-fire test helper

A generic hold test can repeatedly issue `forceWeaponFire` for a requested duration:

```sqf
params
[
    "_plane",
    "_duration",
    "_weapon",
    "_mode"
];

private _shooter = driver _plane;
private _endTime = diag_tickTime + _duration;

while
{
    diag_tickTime < _endTime
    && {alive _plane}
    && {alive _shooter}
}
do
{
    _shooter forceWeaponFire
    [
        _weapon,
        _mode
    ];

    uiSleep 0.02;
};
```

Example calls:

```sqf
[gau8_test_plane_rhs, 10, "RHS_weap_gau8", "HighROF"]
    execVM "compat_hold_test.sqf";

[gau8_test_plane_rhs, 10, "RHS_weap_gau8", "LowROF"]
    execVM "compat_hold_test.sqf";

[gau8_test_plane_fir, 10, "FIR_GAU8", "FIR_GAU8"]
    execVM "compat_hold_test.sqf";

[gau8_test_plane_van, 10, "Gatling_30mm_Plane_CAS_01_F", "LowROF"]
    execVM "compat_hold_test.sqf";
```

### Acceptance checklist

For every supported aircraft:

- Cannon appears in the weapon selector
- Ammunition is present
- Weapon fires normally
- Ammunition count decreases
- Projectiles and impacts are unchanged
- Scripted GAU-8 audio starts
- Sustained sound follows trigger duration
- End phase plays after release
- External delay increases with distance
- Close, medium, and far transitions are smooth
- Doppler works during passes
- Cockpit audio is distinct from external audio
- No duplicate original cannon report remains
- Native projectile cracks remain audible
- RHS HighROF does not retain a JSRS duplicate report
- AI firing modes still trigger the scripted system

---

## Troubleshooting

### The mod builds, but no scripted cannon sound plays

Check the registry:

```sqf
missionNamespace getVariable
[
    "gau_gau8_weaponRegistry",
    []
]
```

Check the aircraft handler:

```sqf
vehicle player getVariable
[
    "gau_gau8_firedHandler",
    -1
]
```

Confirm the Fired event’s actual weapon, muzzle, mode, ammo, and magazine values. Third-party mods sometimes report a mode name that differs from the configured `modes[]` entry.

### The original cannon report is still audible

Possible causes:

- The compatibility addon did not load.
- A later sound mod overwrote `StandardSound`.
- A third-party update changed the class hierarchy.
- JSRS loaded an additional compatibility patch after this mod.
- The local development build and Workshop copy are both active.

Inspect the final values of:

```text
StandardSound/begin1
StandardSound/soundSetShot
weaponSoundEffect
```

For RHS with JSRS, confirm that `gau_gau8_rhsusaf_jsrs2025_compat` loaded after the JSRS RHS compatibility patch through `requiredAddons[]`.

### The cannon disappeared from the weapon selector

This normally indicates broken weapon inheritance.

Confirm:

```sqf
getNumber
(
    configFile
    >> "CfgWeapons"
    >> "RHS_weap_gau8"
    >> "scope"
)
```

and:

```sqf
getNumber
(
    configFile
    >> "CfgWeapons"
    >> "FIR_GAU8"
    >> "scope"
)
```

Both should be nonzero.

Also check the aircraft’s actual weapon list:

```sqf
vehicle player weaponsTurret [-1]
```

### HEMTT reports “class defined multiple times”

Do not use a forward declaration followed by a new definition of the same third-party class in a form that HEMTT treats as duplicate.

Avoid:

```cpp
class FIR_GAU8;

class FIR_GAU8
{
};
```

Use one correctly inherited class definition.

### HEMTT reports missing final newline

Run:

```powershell
hemtt utils fnl
```

### HEMTT reports unused external class declarations

Remove only declarations that are genuinely unused. Do not remove nested base-class declarations that are required by an inherited `StandardSound` class.

### Arma appears to load the wrong copy

Completely close:

- Arma 3
- Arma 3 Launcher
- Arma 3 Publisher

Then disable or remove the development symlink and launch only the subscribed Workshop copy.

The active development namespace should be:

```text
<Arma 3>\z\gau
```

The old namespace:

```text
<Arma 3>\z\big
```

should not remain active.

### Git shows untracked backups or package files

Do not stage generated archives, `.hemttout`, or backups.

Recommended `.gitignore` entries:

```gitignore
.hemttout/
backups/
releases/
*.zip
```

Review before committing:

```powershell
git status --short
git diff --check
git diff --cached --check
git diff --cached --stat
```

---

## Publishing

### HEMTT release

```powershell
Set-Location C:\ArmaDev\gau8_acoustics

git status --short
git diff --check

hemtt check
hemtt release
```

Use:

```text
.hemttout\release
```

as the Publisher mod folder.

Do not publish `.hemttout\dev`.

### Steam Workshop first upload

1. Open Arma 3 Tools.
2. Open Publisher.
3. Select **Unpublished item**.
4. Select `.hemttout\release` as the mod folder.
5. Add the title, description, tags, and preview image.
6. Set visibility to **Private** initially.
7. Publish.
8. Subscribe to the item.
9. Disable the local development build.
10. Test the downloaded Workshop copy.
11. Change visibility to **Public** after validation.

RHSUSAF, Firewill, and JSRS are optional integrations and should not be marked as mandatory Workshop dependencies unless the base mod is changed to require them.

### Updating the Workshop item

```powershell
hemtt check
hemtt release
```

In Publisher, select the existing Workshop item, choose the new `.hemttout\release` folder, enter change notes, and publish the update.

---

## Known limitations

- The acoustic model is an approximation designed for convincing gameplay, not a full wave solver.
- Sound speed is currently fixed at approximately `343 m/s`; temperature, humidity, and altitude are not used to vary it.
- Obstruction uses game-world geometry and cannot reproduce full diffraction.
- Ground response is a simplified interference treatment rather than physically complete reflection modeling.
- Listener and source motion are sampled through the game scripting environment.
- Very low or unstable frame rates can reduce scheduling precision.
- Third-party weapon and sound-mod updates can change class names or inheritance.
- Native projectile crack behavior depends on the loaded ammunition configuration.
- The mod does not simulate hearing damage, nonlinear air propagation, or microphone recording characteristics.
- The current compatibility list is limited to the tested vanilla, RHSUSAF, Firewill, and JSRS configurations.

---

## Version history

### V11.1 — `gau` namespace migration

- Changed personal namespace from `big` to `gau`
- Changed PBO prefixes from `z\big` to `z\gau`
- Changed patch, function, and runtime-variable prefixes from `big_gau8_*` to `gau_gau8_*`
- Removed old namespace aliases before public release

### V11.0 — Firewill and RHSUSAF compatibility

- Added generic supported-weapon registry
- Added Firewill `FIR_GAU8` compatibility
- Added RHSUSAF `RHS_weap_gau8` compatibility
- Added RHSUSAF/JSRS 2025 suppression patch
- Preserved third-party inheritance, modes, magazines, ammunition, and impacts
- Generalized aircraft discovery and handler installation

### V10 — Presence and Doppler

- Added external gain refinements
- Corrected `playSound3D` pitch wiring
- Added presence-focused equalization
- Increased sustained-grain density
- Added diffuse environmental tails
- Increased far-body level

### V9 — Environmental behavior

- Added arrival-time obstruction
- Added arrival recalculation
- Replaced discrete ground reflection with single-voice ground interference
- Added AI firing-mode handling
- Moved timing to `diag_tickTime` and `uiSleep`
- Standardized nominal sound speed at `343 m/s`
- Added Doppler processing

### V8 — Cockpit system

- Added dedicated internal-camera detection
- Added `playSoundUI` cockpit presentation
- Added cockpit cannon and airframe layers
- Added deterministic shot-clock scheduling

### V7 — Directivity

- Added distance-dependent body directivity
- Added strong muzzle forward radiation
- Kept the mechanical layer effectively omnidirectional

### V6 — Distance spectra

- Added close, medium, and far distance regions
- Added constant-sum close-to-medium blending
- Added equal-power medium-to-far blending

### V5

- Synthetic crack layer was evaluated and rejected
- Native projectile cracks were retained

### V4

- Adopted the accepted recording set
- Added dedicated starts, six sustain grains, and ends
- Used the close source’s right channel
- Applied stereo downmix processing to the far source

### Earlier development

- Added the granular scheduler
- Brightened the close body
- Removed crackle introduced during brightening
- Established scripted propagation delay and historical source positioning

---

## Credits, source material, and licensing

### Development

Project repository owner:

```text
Bigg-ie
```

### Third-party trademarks and content

Arma 3 and Bohemia Interactive names and assets belong to their respective owners.

RHSUSAF, Firewill, and JSRS are third-party projects owned by their respective authors. This project provides optional configuration compatibility and does not claim ownership of those projects.

### Audio and source material

Only publish or redistribute audio for which you have the necessary rights.

Record the provenance and license status of every included source recording, processed sample, image, and external asset. Development references that are not used in the shipped mod should not be included in the release package.

### Repository license

This README does not grant permission to copy, modify, or redistribute the source code or audio assets.

Add a repository `LICENSE` file before public release and clearly state whether:

- Code and audio use the same license
- Audio assets have separate restrictions
- Third-party source material is excluded
- Contributions are accepted under the project license

Until a license is explicitly provided, normal copyright restrictions apply.

---

## Development policy

For major changes:

1. Create a dedicated Git branch.
2. Build with HEMTT.
3. Run configuration and in-game regression tests.
4. Stage only source files related to the change.
5. Exclude `.hemttout`, backups, generated archives, and test artifacts.
6. Commit only after the change is accepted.
7. Add an annotated tag for accepted milestones.

Example:

```powershell
git status --short
git diff --check
git add .hemtt addons
git diff --cached --check
git diff --cached --stat
git commit -m "Describe the accepted change"
git tag -a gau8-vX.Y-description -m "Accepted milestone description"
git push origin main
git push origin --tags
```
