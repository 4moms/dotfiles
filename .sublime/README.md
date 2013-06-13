This folder contains three files that will need to be added to the User/ folder in Sublime Packages.

I named the files differently in dotfiles so the names better reflect what they do.

From Sublime Text, Click the Sublime Text 2 menu, then select 'Preferences', then select 'Browse Packages...'

The files replace the ones located in the User folder, and go as follows

- InstalledPackages.sublime-settings replaces User/Package Control.sublime-settings
- UserKeybindings.sublime-keymap replaces User/Default (OSX).sublime-keymap
- UserPreferences.sublime-settings replaces User/Preferences.sublime-settings

The Railscasts.tmTheme can be dropped into the "Color Scheme - Default" in the Packages folder

The InstalledPackages.sublime-settings file contains all packaged installed. When you restart sublime all teh packages in this file will be installed.