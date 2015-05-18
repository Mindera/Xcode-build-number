# Xcode-build-number

A xcode small build script to automate the include of the build number in the Settings.bundle __root.plist__ file.

## Use it on your great project

1. Ignore this step if you already have a __Settings.bundle__ configured in your project
   * Add a __Settings.bundle__ file to your project
   * Locate the file and open the __root.plist__ file inside
   * Add two (or one) preference items and provide a value to the _identifier_ __(you will need this value later)__
2. Add this file to the root folder of your project;
3. On Xcode, go to Project settings __>__ target __>__ Build Phases __>__ Run Script (If none, press the __+__ button on the top left of that section and add a __Run Script phase__; 
4. On the __Shell__ section, use _/bin/sh_;
5. Add the call to the script on the section `""${SRCROOT}/xcode-build-number.sh" -b "<your_app_build_number_key>" -v "<your_app_version_key>"`;
6. Cross your fingers __(not needed :D)__ and run the app;
7. Check the settings section on the application

## Features

- [X] Xcode build script
- [X] Custom values for keys on the __root.plist__ file
- [ ] Custom read of __.plist__ file
- [ ] Custom write on __.plist__ file
- [ ] Automate include and creation of keys if needed