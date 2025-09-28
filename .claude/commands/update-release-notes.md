# /update-release-notes

Create multilingual release notes for App Store submission based on git changes.

## Workflow

This command will execute the following workflow:

1. **Determine Comparison Base**
   - Default: Fetch the latest release tag from GitHub using `gh release list --exclude-pre-releases --exclude-drafts --limit 1`
   - Alternative: Use specified tag if provided
   - Get git diff from the base tag to current HEAD

2. **Analyze Changes**
   - Review commit messages with `git log --oneline [tag]..HEAD`
   - Check changed files with `git diff --stat [tag]..HEAD`
   - Identify user-facing changes from commits

3. **Create English Release Notes**
   - Analyze all changes and identify user-facing improvements
   - Focus on features that affect user experience:
     - New features and functionality
     - UI/UX improvements
     - Performance enhancements
     - Bug fixes visible to users
   - Exclude technical changes (CI/CD, documentation, internal refactoring)
   - Write concise bullet points (max 8 items)
   - Save to `fastlane/metadata/en-US/release_notes.txt`

4. **Translate to All Languages**
   - Use the Task tool to create native translations for all supported languages
   - Maintain bullet point format (•) for consistency
   - Ensure translations are appropriate for App Store listings
   - Target languages include:
     - Asian: ja, zh-Hans, zh-Hant, ko, hi, th, vi, id, ms
     - European: es-ES, es-MX, fr-FR, fr-CA, de-DE, it, pt-BR, pt-PT, ru, nl-NL
     - Nordic: sv, no, da, fi
     - Eastern European: pl, cs, sk, hu, ro, hr, uk
     - Middle Eastern: tr, ar-SA, he
     - Other: el, ca
     - English variants: en-GB, en-AU, en-CA

5. **Save All Translations**
   - Write each translation to `fastlane/metadata/[locale]/release_notes.txt`
   - Verify all files are created successfully

## Usage Examples

```
/update-release-notes
```
Create release notes from the latest GitHub release to current HEAD (default)

```
/update-release-notes v1.0.0
```
Create release notes comparing v1.0.0 to current HEAD

```
/update-release-notes v1.0.0 v1.0.1
```
Create release notes comparing v1.0.0 to v1.0.1

## Parameters

- `from_tag` (optional): Starting git tag for comparison. If not specified, uses the latest GitHub release tag (excluding pre-releases and drafts)
- `to_ref` (optional): Ending git reference (tag, commit, or HEAD). Defaults to HEAD

## Implementation Steps

```bash
# 1. Get latest release tag (if not specified)
gh release list --exclude-pre-releases --exclude-drafts --limit 1 --json tagName -q '.[0].tagName'

# 2. Get commit history
git log --oneline [from_tag]..[to_ref]

# 3. Get file changes summary
git diff --stat [from_tag]..[to_ref]
```

## Notes

- Keep release notes concise and user-focused
- Maximum 8 bullet points for readability
- Each point should be one line
- Focus on what users will notice and care about
- Use simple, clear language suitable for all users
- Maintain consistent formatting across all languages
- The command automatically detects the latest stable release from GitHub (excludes pre-releases and drafts), making it easy to generate notes for the next release