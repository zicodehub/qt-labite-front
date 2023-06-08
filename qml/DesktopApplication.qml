import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import ThemeEngine 1.0
import "./components_generic"
import "./models"

ApplicationWindow {
    id: appWindow
    flags: settingsManager.appThemeCSD ? Qt.Window | Qt.FramelessWindowHint : Qt.Window
    color: settingsManager.appThemeCSD ? "transparent" : Theme.colorBackground

    property bool isDesktop: true
    property bool isMobile: false
    property bool isPhone: false
    property bool isTablet: false
    property bool isHdpi: (utilsScreen.screenDpi > 128 || utilsScreen.screenPar > 1.0)

    // Desktop stuff ///////////////////////////////////////////////////////////

    minimumWidth: 800
    minimumHeight: 560

    width: {
        if (settingsManager.initialSize.width > 0)
            return settingsManager.initialSize.width
        else
            return isHdpi ? 800 : 1280
    }
    height: {
        if (settingsManager.initialSize.height > 0)
            return settingsManager.initialSize.height
        else
            return isHdpi ? 560 : 720
    }
    x: settingsManager.initialPosition.width
    y: settingsManager.initialPosition.height
    visibility: settingsManager.initialVisibility
    visible: true

    WindowGeometrySaver {
        windowInstance: appWindow
        Component.onCompleted: {
            // Make sure we handle window visibility correctly
            visibility = settingsManager.initialVisibility
        }
    }

    // Mobile stuff ////////////////////////////////////////////////////////////

    property int screenOrientation: Screen.primaryOrientation
    property int screenOrientationFull: Screen.orientation

    property int screenPaddingStatusbar: 0
    property int screenPaddingNotch: 0
    property int screenPaddingLeft: 0
    property int screenPaddingRight: 0
    property int screenPaddingBottom: 0

    property alias $Colors: __colors
    property alias $Models: __models
    property alias $Constants: __constants

    // Events handling /////////////////////////////////////////////////////////

    //onActiveFocusItemChanged: print("activeFocusItem", activeFocusItem)

    Component.onCompleted: {
        //
    }

    ModelManager {
        id: __models
    }

    Colors {
        id: __colors
    }

    Constants {
        id: __constants
    }

    Connections {
        target: appHeader
        function onBackButtonClicked() {
            if (appContent.state !== "MainView") {
                appContent.state = "MainView"
            }
        }

        function onRefreshButtonClicked() {
            //
        }

        function onMainButtonClicked() { appContent.state = "MainView" }
        function onStoreButtonClicked() { appContent.state = "StoreView" }
        function onOrderButtonClicked() { appContent.state = "OrderView" }
        function onGarageButtonClicked() { appContent.state = "GarageView" }
        function onSettingsButtonClicked() { appContent.state = "Settings" }
        function onAboutButtonClicked() { appContent.state = "About" }
    }

    Connections {
        target: Qt.application
        function onStateChanged() {
            switch (Qt.application.state) {
                case Qt.ApplicationActive:
                    //console.log("Qt.ApplicationActive")

                    // Check if we need an 'automatic' theme change
                    Theme.loadTheme(settingsManager.appTheme)
                    break
            }
        }
    }

    onClosing: (close) =>  {
        if (Qt.platform.os === "osx") {
            close.accepted = false
            appWindow.hide()
        }
    }

    // User generated events handling //////////////////////////////////////////

    function backAction() {
        //
    }
    function forwardAction() {
        //
    }
    function deselectAction() {
        //
    }

    MouseArea {
        anchors.fill: parent
        z: 99
        acceptedButtons: Qt.BackButton | Qt.ForwardButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.BackButton) {
                backAction()
            } else if (mouse.button === Qt.ForwardButton) {
                forwardAction()
            }
        }
    }

    Shortcut {
        sequences: [StandardKey.Back, StandardKey.Backspace]
        onActivated: backAction()
    }
    Shortcut {
        sequences: [StandardKey.Forward]
        onActivated: forwardAction()
    }
    Shortcut {
        sequences: [StandardKey.Refresh]
        //onActivated: //
    }
    Shortcut {
        sequence: "Ctrl+F5"
        //onActivated: //
    }
    Shortcut {
        sequences: [StandardKey.Deselect, StandardKey.Cancel]
        onActivated: deselectAction()
    }
    Shortcut {
        sequence: StandardKey.Preferences
        onActivated: appContent.state = "Settings"
    }
    Shortcut {
        sequences: [StandardKey.Close]
        onActivated: appWindow.close()
    }
    Shortcut {
        sequence: StandardKey.Quit
        onActivated: appWindow.exit(0)
    }

    // UI sizes ////////////////////////////////////////////////////////////////

    property bool headerUnicolor: (Theme.colorHeader === Theme.colorBackground)
    property bool sidebarUnicolor: (Theme.colorSidebar === Theme.colorBackground)

    property bool singleColumn: {
        if (isMobile) {
            if (screenOrientation === Qt.PortraitOrientation ||
                (isTablet && width < 480)) { // can be a 2/3 split screen on tablet
                return true
            } else {
                return false
            }
        } else {
            return (appWindow.width < appWindow.height)
        }
    }

    property bool wideMode: (isDesktop && width >= 560) || (isTablet && width >= 480)
    property bool wideWideMode: (width >= 640)

    // Menubar /////////////////////////////////////////////////////////////////
/*
    menuBar: MenuBar {
        id: appMenubar
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Do nothing")
                onTriggered: console.log("Do nothing action triggered");
            }
            MenuItem {
                text: qsTr("&Exit")
                onTriggered: Qt.quit();
            }
        }
    }
*/
    // QML /////////////////////////////////////////////////////////////////////

    DesktopHeader {
        id: appHeader

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Item {
        id: appContent

        anchors.top: appHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        MainView {
            anchors.fill: parent
            id: screenMainView
        }

        StoreView {
            anchors.fill: parent
            id: screenStoreView
        }

        OrderView {
            anchors.fill: parent
            id: screenOrderView
        }

        GarageView {
            anchors.fill: parent
            id: screenGarageView
        }

        FontList {
            anchors.fill: parent
            id: screenFontList
        }
        HostInfos {
            anchors.fill: parent
            id: screenHostInfos
        }

        Settings {
            anchors.fill: parent
            id: screenSettings
        }
        About {
            anchors.fill: parent
            id: screenAbout
        }

        Component.onCompleted: {
            //
        }

        // Initial state
        state: "MainView"

        onStateChanged: {
            //
        }

        states: [
            State {
                name: "MainView"
                PropertyChanges { target: screenMainView; visible: true; enabled: true; focus: true; }
                PropertyChanges { target: screenFontList; visible: false; enabled: false; }
                PropertyChanges { target: screenHostInfos; visible: false; enabled: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenStoreView; visible: false; enabled: true; focus: false; }
                PropertyChanges { target: screenOrderView; visible: false; enabled: false; focus: false }
                PropertyChanges { target: screenGarageView; visible: false; enabled: false; focus: false; }
            },
            State {
                name: "StoreView"
                PropertyChanges { target: screenMainView; visible: false; enabled: true; focus: false; }
                PropertyChanges { target: screenFontList; visible: false; enabled: false; }
                PropertyChanges { target: screenHostInfos; visible: false; enabled: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenStoreView; visible: true; enabled: true; focus: true; }
                PropertyChanges { target: screenOrderView; visible: false; enabled: false; focus: false }
                PropertyChanges { target: screenGarageView; visible: false; enabled: false; focus: false; }
            },
            State {
                name: "OrderView"
                PropertyChanges { target: screenMainView; visible: false; enabled: true; focus: false; }
                PropertyChanges { target: screenFontList; visible: false; enabled: false; }
                PropertyChanges { target: screenHostInfos; visible: false; enabled: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenStoreView; visible: false; enabled: false; focus: false; }
                PropertyChanges { target: screenOrderView; visible: true; enabled: true; focus: true }
                PropertyChanges { target: screenGarageView; visible: false; enabled: false; focus: false; }
            },
            State {
                name: "GarageView"
                PropertyChanges { target: screenMainView; visible: false; enabled: true; focus: false; }
                PropertyChanges { target: screenFontList; visible: false; enabled: false; }
                PropertyChanges { target: screenHostInfos; visible: false; enabled: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenStoreView; visible: false; enabled: false; focus: false; }
                PropertyChanges { target: screenOrderView; visible: false; enabled: false; focus: false }
                PropertyChanges { target: screenGarageView; visible: true; enabled: true; focus: true; }
            },
            State {
                name: "FontList"
                PropertyChanges { target: screenMainView; visible: false; enabled: false; }
                PropertyChanges { target: screenFontList; visible: true; enabled: true; focus: true; }
                PropertyChanges { target: screenHostInfos; visible: false; enabled: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenStoreView; visible: false; enabled: true; focus: false; }
                PropertyChanges { target: screenOrderView; visible: false; enabled: false; focus: false }
                PropertyChanges { target: screenGarageView; visible: false; enabled: false; focus: false; }
            },
            State {
                name: "HostInfos"
                PropertyChanges { target: screenMainView; visible: false; enabled: false; }
                PropertyChanges { target: screenFontList; visible: false; enabled: false; }
                PropertyChanges { target: screenHostInfos; visible: true; enabled: true; focus: true; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenStoreView; visible: false; enabled: true; focus: false; }
                PropertyChanges { target: screenOrderView; visible: false; enabled: false; focus: false }
                PropertyChanges { target: screenGarageView; visible: false; enabled: false; focus: false; }
            },
            State {
                name: "Settings"
                PropertyChanges { target: screenMainView; visible: false; enabled: false; }
                PropertyChanges { target: screenFontList; visible: false; enabled: false; }
                PropertyChanges { target: screenHostInfos; visible: false; enabled: false; }
                PropertyChanges { target: screenSettings; visible: true; enabled: true; focus: true; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenStoreView; visible: false; enabled: true; focus: false; }
                PropertyChanges { target: screenOrderView; visible: false; enabled: false; focus: false }
                PropertyChanges { target: screenGarageView; visible: false; enabled: false; focus: false; }
            },
            State {
                name: "About"
                PropertyChanges { target: screenMainView; visible: false; enabled: false; }
                PropertyChanges { target: screenFontList; visible: false; enabled: false; }
                PropertyChanges { target: screenHostInfos; visible: false; enabled: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: true; enabled: true; focus: true; }
                PropertyChanges { target: screenStoreView; visible: false; enabled: true; focus: false; }
                PropertyChanges { target: screenOrderView; visible: false; enabled: false; focus: false }
                PropertyChanges { target: screenGarageView; visible: false; enabled: false; focus: false; }
            }
        ]
    }
}
