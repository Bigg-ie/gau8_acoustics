# GAU-8 Acoustic Simulation — current implementation notes

The current `main` branch contains acoustic refinements newer than the latest tagged 1.2.0 release. Internal V27 numbers are development lineage and are not public version numbers.

## External cannon report

The external report uses overlapping 480 ms long grains derived from the current report source material. Close, medium, and far banks are scheduled independently of the supersonic projectile crack field. Each sustain emission recalculates source position, distance weighting, directivity, obstruction, ground response, and propagation timing.

Emission spacing is randomized over five to eight 65 Hz firing intervals. Attack audio overlaps the first sustain emissions. Existing sustain grains are never hard-stopped when the trigger is released.

The dedicated `mr_body_release_*` report bank is disabled by default. Burst termination is instead formed by the natural decay of already-emitted sustain grains plus one guaranteed environment-only response derived from the final sustain state.

Default report masters:

- Attack: `5.0`
- Sustain: `5.0`

## Pitch and Doppler

The accepted report source has a pulse structure of approximately 107.623318 Hz. The stationary GAU-8 reference is 65 Hz, giving a stationary source-rate multiplier of approximately `0.603958333`.

Receding report Doppler uses the full radial-velocity factor by default. Approaching report Doppler uses a calibrated excursion master of `1.45`. The direct approach playback cap is approximately `1.03` times the original source-recording pitch by default. This allows a representative strong approach to return close to the source recording's cadence without allowing extreme radial velocities to drive the cannon into an implausibly high-rate presentation.

## Distance field

Close, medium, and far report gains are recalculated for every sustain emission.

The current close-to-medium perspective is:

- 0–400 m: close bank fully dominant
- 500 m: 95% close / 5% medium
- 600 m: 85% close / 15% medium
- 700 m: 65% close / 35% medium
- 800 m: 45% close / 55% medium
- 950 m: 25% close / 75% medium
- 1100 m: 10% close / 90% medium
- 1250–1500 m: medium-only plateau

The medium-to-far transition begins at approximately 1500 m and completes at approximately 3000 m. That transition retains the equal-power-style square-root weighting used by the report architecture.

The overall report distance-gain curve is separate and was not changed when these perspective distances were extended.

The muzzle-support layer is also separate from the stretched close-body curve. It retains its short-range behavior and reaches zero at approximately 250 m.

## Terminal environmental decay

During sustain, the scheduler records the latest report state:

- representative close/medium/far grain path
- emission position
- arrival timing state
- combined close/medium/far body energy
- playback pitch
- source velocity
- emission tick

At trigger release, that state is queued once as an **environment-only** event. Dry playback of the report grain is suppressed for this event, but the normal arrival-time geometry, Doppler, obstruction, ground, and environment calculations remain available to the environmental response.

The terminal send level is derived from:

```text
sqrt(closeGain^2 + midGain^2 + farGain^2)
```

The strongest current distance bank supplies the representative report path used for event classification. The terminal response bypasses the normal sparse-tail throttle so one environment decay is guaranteed. Its default relative event scale is `1.10`.

This replaces the previous behavior in which a distinct recorded release report could impose its own terminal pitch contour.

## Environment

Terrain and object obstruction are evaluated at arrival. Ground-interference coloration is applied as a gain response; the default report ground-response depth is `0.30`.

Normal sustained fire uses sparse environmental tails selected from the existing open and enclosed environment banks. Burst termination adds the guaranteed environment-only response described above.

Vehicle listener space and world environmental enclosure are separate states. A listener can therefore be exterior to the aircraft acoustically while standing in an enclosed world location.

## Supersonic projectile cracks

The supersonic crack system uses Mach-wave geometry rather than the cannon report's close/medium/far weights. It includes the direct N-wave crack, body/detail support, reflection field, scatter, and terminal/environmental tails.

Default supersonic-crack output master:

- `gau_gau8_ripOutputMaster = 0.40`

The public-facing system uses distance-dependent direct-crack timbre banks:

- below 600 m: original direct crack
- 600–1199 m: softened medium-distance crack
- 1200–2199 m: softer far-distance crack
- 2200 m and beyond: strongest high-frequency attenuation

The direct-crack distance-timbre switch is performed per event; the system does not duplicate multiple direct-crack banks during a crossover.

## Listener space and cockpit behavior

`gau_gau8_fnc_getListenerState` owns the source-aircraft listener classification:

- `INTERIOR`
- `EXTERIOR`

The cannon mix uses a smoothed interior/exterior transition. External cannon body, mechanical, and muzzle gains consume the exterior mix; dedicated cockpit body and airframe layers consume the interior mix.

Delayed supersonic-crack playback queries the same listener-space classification at actual arrival time. Crack layers are exterior-only for a listener inside the source aircraft cockpit. This crack query is intentionally unsmoothed so delayed crack events do not advance the cannon mix's smoothing state multiple times.

World environment remains independent of vehicle listener space.

## A-10-tastic compatibility

The optional `gau_gau8_a10tastic_compat` addon:

- suppresses A-10-tastic's external and internal GAU-8 SoundSets
- preserves A-10-tastic engine and airframe audio
- registers A-10-tastic's 1-second, 2-second, and 3-second GAU-8 firing modes
- supports the vanilla, RHSUSAF, Firewill, USAF, and CUP GAU-8 weapon families handled by A-10-tastic

This allows A-10-tastic to continue supplying its aircraft audio while this project supplies the cannon report and supersonic projectile crack system.

## Compatibility

The base addon handles the vanilla A-164 weapon. Separate compatibility addons register RHSUSAF, Firewill, USAF, CUP, and A-10-tastic integrations. JSRS compatibility prevents a second cannon report from playing over the scripted system.
