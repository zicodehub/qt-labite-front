# Blume Plant Selector

[![License: GPL v3](https://img.shields.io/badge/license-GPL%20v3-blue.svg?style=flat-square)](http://www.gnu.org/licenses/gpl-3.0)

Cette application permet d'avoir une globale sur les plantes associées associées à l'application Blume !

## About

### Dependencies

You will need a C++17 compiler and Qt 6.5+. Qt 5 Compatibility Module is required.  
For macOS and iOS builds, you'll need Xcode (13+) installed.  
For Android builds, you'll need the appropriates JDK (11) SDK (24+) and NDK (25+). You can customize Android build environment using the `assets/android/gradle.properties` file.  

#### Building QmlAppTemplate

```bash
$ git clone https://github.com/mahoudev/blume-plant-selector.git
$ cd blume-plant-selector/build/
$ qmake .. # configure with QMake
$ cmake .. # OR with CMake
$ make
```

### C++ modules

> [AppUtils](src/thirdparty/AppUtils/README.md) Various general purpose helpers

> [MobileUI](src/thirdparty/MobileUI/README.md) Interract with Android and iOS UI

> [MobileSharing](src/thirdparty/MobileSharing/README.md) Use Android and iOS "sharing" features

> [SingleApplication](src/thirdparty/SingleApplication/README.md) Keep only one active instance of your application

> [QmlRadialBar](src/thirdparty/QmlRadialBar/README.md) A radial bar reusable component for QML

### QML components

> TODO

### Deploy scripts

> [Linux](deploy_linux.sh) AppImage

> [macOS](deploy_macos.sh) application zip

> [Windows](deploy_windows.sh) application zip and NSIS installer

### GitHub CI workflows

These files are also useful to get an idea about the whole build and deploy process.

> [Desktop](.github/workflows/builds_desktop.yml) Linux, macOS and Windows workflow

> [Mobile](.github/workflows/builds_mobile.yml) Android and iOS workflow

> [Linux flatpak](.github/workflows/flatpak.yml)
