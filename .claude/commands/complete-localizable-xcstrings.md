# Complete Localization for Localizable.xcstrings Files

## Task
Complete the localization for all untranslated strings in the project's Localizable.xcstrings files. The project contains multiple localization files that need to be updated with translations for all supported languages.

## Files to Process
1. `/Sources/UI/Resources/Localizable.xcstrings`
2. `/Sources/Resources/Localizable.xcstrings`

## Target Languages
The project supports the following languages:
- English (en) - Source language
- Japanese (ja)
- Thai (th)
- Chinese Simplified (zh-Hans)
- Chinese Traditional (zh-Hant)

## Instructions

1. **Analyze each Localizable.xcstrings file**:
   - Read the entire content of each file
   - Identify strings that are missing translations for any of the target languages
   - Note strings where only some languages have translations

2. **Add missing translations**:
   - For each string that lacks translations in any target language, add the appropriate translation
   - Ensure translations are contextually appropriate for a stopwatch/timer application
   - Maintain consistency with existing translations in tone and terminology

3. **Translation Guidelines**:
   - Keep translations concise and appropriate for UI elements
   - Consider button labels, menu items, and short messages
   - Use formal/polite forms where culturally appropriate
   - For technical terms (like "Lap", "Split", etc.), use commonly accepted translations in each language
   - Preserve any format specifiers (like %@, %lld) in the exact same position and format

4. **JSON Structure**:
   - Maintain the exact JSON structure of the xcstrings format
   - Each translation should include `"state" : "translated"`
   - Preserve any existing translations and only add missing ones

5. **Context for Translation**:
   This is a stopwatch/timer application with the following features:
   - Start, Stop, Resume, Reset controls
   - Lap time tracking
   - Export functionality (CSV format)
   - Preferences for appearance and behavior
   - Sound and haptic feedback options
   - Color customization

6. **Common Terms Reference**:
   - "Start" - Begin timing
   - "Stop" - Pause timing
   - "Resume" - Continue timing after pause
   - "Reset" - Clear all timing data
   - "Lap" - Record split time
   - "Export" - Save data to file
   - "Preferences" - Application settings

7. **Quality Checks**:
   - Verify all strings have translations for all target languages
   - Ensure no duplicate keys exist
   - Validate JSON syntax is correct
   - Check that format specifiers are preserved correctly
   - Confirm cultural appropriateness of translations

## Example Entry Structure
```json
"String Key": {
  "localizations": {
    "en": {
      "stringUnit": {
        "state": "translated",
        "value": "English Text"
      }
    },
    "ja": {
      "stringUnit": {
        "state": "translated",
        "value": "日本語テキスト"
      }
    },
    "th": {
      "stringUnit": {
        "state": "translated",
        "value": "ข้อความภาษาไทย"
      }
    },
    "zh-Hans": {
      "stringUnit": {
        "state": "translated",
        "value": "简体中文文本"
      }
    },
    "zh-Hant": {
      "stringUnit": {
        "state": "translated",
        "value": "繁體中文文本"
      }
    }
  }
}
```

## Execution Steps

1. Start by reading both Localizable.xcstrings files
2. Create a list of all strings that need translations
3. For each string, provide translations in all missing languages
4. Use the Edit or MultiEdit tool to update each file with the complete translations
5. Verify the JSON syntax is valid after making changes
6. Ensure all strings in both files have complete translations for all supported languages

## Notes
- Some strings like ":", ".", or empty strings ("") may not need translations as they are punctuation marks
- Focus on meaningful text strings that appear in the user interface
- If a string already has a translation for a language, do not modify it unless it's clearly incorrect
- The `"state": "translated"` field is important for the build system to recognize completed translations