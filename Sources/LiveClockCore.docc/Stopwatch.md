# ``LiveClockCore/Stopwatch``

A high-precision stopwatch with lap tracking capabilities.

## Overview

The `Stopwatch` class provides millisecond-precision timing with support for start, pause, resume, reset, and lap recording functionality. It uses monotonic time to ensure accuracy even during system time changes.

## Topics

### Managing State

- ``state``
- ``start()``
- ``pause()``
- ``reset()``

### Tracking Time

- ``elapsed``
- ``tick()``

### Recording Laps

- ``laps``
- ``lap()``

## Example

```swift
let stopwatch = Stopwatch()

// Start timing
stopwatch.start()

// Record a lap
stopwatch.lap()

// Pause timing
stopwatch.pause()

// Resume timing
stopwatch.start()

// Reset everything
stopwatch.reset()
```