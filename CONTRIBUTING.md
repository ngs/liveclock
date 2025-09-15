# Contributing to LiveClock

Thank you for your interest in contributing to LiveClock! We welcome contributions from the community.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/liveclock.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Run tests: `swift test`
6. Commit your changes: `git commit -am 'Add new feature'`
7. Push to your branch: `git push origin feature/your-feature-name`
8. Create a Pull Request

## Development Setup

### Prerequisites

- Xcode 15.0 or later
- macOS 14.0 or later
- Swift 5.9 or later

### Building with Tuist

```bash
tuist generate
open LiveClock.xcworkspace
```

### Building with Swift Package Manager

Open `Package.swift` in Xcode and follow the instructions in `PROJECT_SETUP.md`.

## Code Style

- Follow Swift API Design Guidelines
- Use SwiftLint (configuration in `.swiftlint.yml`)
- Run `swiftlint` before committing
- Keep code clean and well-documented

## Testing

- Write unit tests for new functionality
- Ensure all tests pass before submitting PR
- Run tests with: `swift test`

## Pull Request Guidelines

1. **PR Title**: Use clear, descriptive titles
2. **Description**: Explain what changes you made and why
3. **Small PRs**: Keep pull requests focused and small
4. **Tests**: Include tests for new features
5. **Documentation**: Update documentation as needed

## Commit Message Format

Follow conventional commits format:

```
type(scope): subject

body

footer
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

## Reporting Issues

- Use GitHub Issues to report bugs
- Include steps to reproduce
- Provide system information (OS version, device type)
- Include crash logs if applicable

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive criticism
- Respect different viewpoints and experiences

## Questions?

Feel free to open an issue for any questions about contributing.

## License

By contributing to LiveClock, you agree that your contributions will be licensed under the same license as the project.