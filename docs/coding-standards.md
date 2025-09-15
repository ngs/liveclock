# Coding Standards

## Documentation and Comments

### Language Requirements
- **ALL comments in code MUST be written in English**
- **ALL documentation MUST be written in English**
- **NO exceptions to this rule**

### Examples

Good:
```swift
// Calculate the elapsed time in milliseconds
let elapsed = stopwatch.elapsed

// Dot opacity follows the same blinking pattern as colons
dotOpacity = colonOpacity
```

Bad:
```swift
// ドットも同じように点滅
dotOpacity = colonOpacity
```

### Documentation Style
- Use clear, concise English
- Avoid abbreviations unless widely known
- Keep comments focused on "why" rather than "what"
- Use proper grammar and spelling

### Code Comments
- Inline comments should explain complex logic
- Header comments should describe the purpose of functions/classes
- TODO/FIXME comments must include context and rationale

This standard applies to:
- All Swift source files
- All documentation files
- All configuration files
- All scripts
- All commit messages