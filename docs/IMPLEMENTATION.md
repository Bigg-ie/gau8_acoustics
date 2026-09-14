# GAU-8 Acoustic Simulation 1.2.0 — implementation notes

## External cannon report

The external report uses overlapping long grains derived from the current MR source material. Close, medium, and far banks are scheduled independently of the projectile rip. Each sustain emission recalculates source position, distance weighting, directivity, obstruction, and propagation delay.

Sustain grains are 480 ms source files. Emission spacing is randomized over five to eight 65 Hz firing intervals. Attack audio overlaps the first sustain emissions, and release audio starts while existing sustain grains decay. No sustain voice is hard-stopped at trigger release.

Default report masters:

- Attack: `5.0`
- Sustain/release: `5.0`

## Pitch and Doppler

The accepted report source has a pulse structure of approximately 107.623318 Hz. The stationary GAU-8 reference is 65 Hz, giving a stationary source-rate multiplier of approximately 0.603958333.

Receding report Doppler uses the full radial-velocity factor. Approaching report Doppler also uses the physical factor, but the direct MR playback pitch is capped at `1.00` times the original source pitch by default. This treats the recording itself as the strong-approach reference.

## Distance field

Close, medium, and far report gains are recalculated for every emission. The medium-to-far crossover uses equal-power weighting. The report is emitted from the historical source position used for the propagation calculation.

## Environment

Terrain and object obstruction are evaluated at arrival. Ground-interference coloration is applied as a single-voice gain response; the default MR ground-response depth is `0.30`. Sparse environmental tails are selected from the existing open and enclosed tail banks.

## Ballistic rip

The rip system uses projectile shock geometry rather than the cannon report's close/mid/far weights. It includes direct crack, body/detail support, reflection field, scatter, and terminal/environmental tails.

Default rip output master:

- `gau_gau8_ripOutputMaster = 0.40`

The internal balance of dry crack, body, detail, reflections, scatter, and tails is unchanged from the working pre-1.2.0 mix.

## Cockpit audio

Cockpit playback uses a dedicated internal body/airframe mix and is not presented as an external free-field source.

## Compatibility

The base addon handles the vanilla A-164 weapon. Separate compatibility addons register RHSUSAF, Firewill, USAF, and CUP GAU-8 weapons. JSRS compatibility prevents a second cannon report from playing over the scripted system.
