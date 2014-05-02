syn match PytestPlatform              '\v^(platform(.*))'
syn match PytestTitleDecoration       "\v\={2,}"
syn match PytestTitle                 "\v\s+(test session starts)\s+"
syn match PytestCollecting            "\v(collecting\s+(.*))"
syn match PytestPythonFile            "\v((.*.py\s+))"
syn match PytestFooterFail            "\v\s+((.*)(failed|error) in(.*))\s+"
syn match PytestFooter                "\v\s+((.*)passed in(.*))\s+"
syn match PytestFailures              "\v\s+(FAILURES|ERRORS)\s+"
syn match PytestErrors                "\v^E\s+(.*)"
syn match PytestDelimiter             "\v_{3,}"
syn match PytestFailedTest            "\v_{3,}\s+(.*)\s+_{3,}"
syntax keyword PytestPASSED PASSED
syntax keyword PytestFAILED FAILED

hi def link PytestPythonFile          String
hi def link PytestPlatform            String
hi def link PytestCollecting          String
hi def link PytestTitleDecoration     Comment
hi def link PytestTitle               String
hi def link PytestFooterFail          String
hi def link PytestFooter              String
hi def link PytestFailures            Number
hi def link PytestErrors              Number
hi def link PytestDelimiter           Comment
hi def link PytestFailedTest          Comment
hi def link PytestPASSED  Function
hi def link PytestFAILED  Number
