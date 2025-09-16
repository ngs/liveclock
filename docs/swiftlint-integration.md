# SwiftLint Integration

This project has been configured with SwiftLint and SwiftLintPlugins for automatic code formatting during builds.

## Components Installed

1. **SwiftLintPlugins Package**: Added to `Package.swift` dependencies
2. **Build Phase Script**: `Scripts/swiftlint-fix-build-phase.sh`
3. **Manual Fix Script**: `Scripts/run-swiftlint-fix.sh`

## Usage Options

### Option 1: Manual SwiftLint Fix (Recommended)
Run SwiftLint with auto-fix manually when needed:

```bash
./Scripts/run-swiftlint-fix.sh
```

### Option 2: Command Plugin
Use the SwiftLint command plugin from the package:

```bash
# Run SwiftLint (check only)
swift package plugin swiftlint

# Run SwiftLint with auto-fix
swift package plugin --allow-writing-to-package-directory swiftlint -- --fix
```

### Option 3: Xcode Build Phase (Automatic)
To enable automatic SwiftLint fixing during Xcode builds:

1. Open the project in Xcode
2. Select your app target
3. Go to "Build Phases" tab
4. Click "+" → "New Run Script Phase"
5. Name it "SwiftLint Auto-Fix"
6. Add this script:
   ```bash
   ${SRCROOT}/Scripts/swiftlint-fix-build-phase.sh
   ```
7. Drag this phase to run before "Compile Sources"

### Option 4: Pre-commit Hook
The project already has a pre-commit hook that runs SwiftLint on staged files.

## Configuration

SwiftLint configuration is in `.swiftlint.yml` at the project root.

## Notes

- The SwiftLintPlugins package provides command-line tools that can be run via `swift package plugin`
- For safety reasons, automatic fixing during builds should be used carefully
- The manual script `./Scripts/run-swiftlint-fix.sh` is the safest option for applying fixes
- Always review changes made by SwiftLint auto-fix before committing