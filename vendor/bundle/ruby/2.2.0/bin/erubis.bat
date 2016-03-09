@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"C:\msys64\mingw64\bin\ruby.exe" "C:/Users/gb/IdeaProjects/twitter_notifier/vendor/bundle/ruby/2.2.0/bin/erubis" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"C:\msys64\mingw64\bin\ruby.exe" "%~dpn0" %*
