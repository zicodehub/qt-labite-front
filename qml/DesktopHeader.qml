import QtQuick 2.15

import ThemeEngine 1.0
import "./components_generic"

Rectangle {
    id: header
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    z: 10
    height: 64
    color: Theme.colorHeader

    ////////////////////////////////////////////////////////////////////////////

    signal backButtonClicked()
    signal rightMenuClicked() // compatibility

    signal refreshButtonClicked()

    signal mainButtonClicked()
    signal storeButtonClicked()
    signal orderButtonClicked()
    signal garageButtonClicked()
    signal settingsButtonClicked()
    signal aboutButtonClicked()
    signal deliveryButtonClicked()

    function setActiveMenu() {
        //
    }

    ////////////////////////////////////////////////////////////////////////////

    DragHandler {
        // Drag on the sidebar to drag the whole window // Qt 5.15+
        // Also, prevent clicks below this area
        onActiveChanged: if (active) appWindow.startSystemMove()
        target: null
    }

   Text {
        id: title
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter

        visible: wideMode
        text: "PDPTW - Labité"
        font.bold: true
        font.pixelSize: Theme.fontSizeHeader
        color: Theme.colorHeaderContent
    }

    ////////////////////////////////////////////////////////////////////////////

    Row {
        id: menus
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        //z: 1
        visible: true
        spacing: 12

        ////////////

//        RoundButtonIcon {
//            id: buttonMenu
//            anchors.verticalCenter: parent.verticalCenter

//            source: "qrc:/assets/icons_material/baseline-more_vert-24px.svg"
//            iconColor: Theme.colorHeaderContent
//            backgroundColor: Theme.colorHeaderHighlight

//            onClicked: actionMenu.open()

//            ActionMenu_bottom {
//                id: actionMenu

//                model: ListModel {
//                    id: lmActionMenu
//                    ListElement { t: "itm"; idx: 1; txt: "Action 1"; src: "qrc:/assets/icons/svg/content-save-plus.svg"; }
//                    ListElement { t: "itm"; idx: 2; txt: "Action 2"; src: "qrc:/assets/icons/svg/content-save-plus.svg"; }
//                    ListElement { t: "sep"; }
//                    ListElement { t: "itm"; idx: 3; txt: "Action 3"; src: "qrc:/assets/icons/svg/content-save-plus.svg"; }
//                }

//                onMenuSelected: (index) => {
//                    //console.log("ActionMenu clicked #" + index)
//                }
//            }
//        }

        ////////////

        ButtonCompactable {
            id: buttonRefresh
            anchors.verticalCenter: parent.verticalCenter

            //visible: (deviceManager.bluetooth && menuMain.visible)
            enabled: !screenMainView.isLoading

            source: "qrc:/assets/icons_material/baseline-autorenew-24px.svg"
            textColor: Theme.colorHeaderContent
            iconColor: Theme.colorHeaderContent
            backgroundColor: Theme.colorHeaderHighlight
            text: qsTr("Refresh data")
            tooltipText: text

            property bool isclicked: false
//            onClicked: {
//                isclicked = !isclicked
//                screenMainView.fetchData({shouldClear: true})
//                .then(function (){ isclicked = false })
//                .catch(function (){ isclicked = false })
//            }

            animation: "rotate"
            animationRunning: screenDeliveryView.isRunning
        }

        ////////////
/*
        Rectangle { // separator
            anchors.verticalCenter: parent.verticalCenter
            height: 40
            width: Theme.componentBorderWidth
            color: Theme.colorHeaderHighlight
            visible: (menuTest.visible)
        }

        Row {
            id: menuTest

            DesktopHeaderItem {
                id: menuMainView1
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight

                selected: (appContent.state === "MainView")
                source: "qrc:/assets/icons_material/duotone-touch_app-24px.svg"
                onClicked: mainButtonClicked()
            }
            DesktopHeaderItem {
                id: menuSettings1
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight

                selected: (appContent.state === "Settings")
                text: qsTr("Settings")
                //source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
                onClicked: settingsButtonClicked()
            }
            DesktopHeaderItem {
                id: menuAbout1
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight

                selected: (appContent.state === "About")
                text: qsTr("Infos")
                source: "qrc:/assets/icons_material/outline-info-24px.svg"
                onClicked: aboutButtonClicked()
            }
        }
*/
        ////////////

        Rectangle { // separator
            anchors.verticalCenter: parent.verticalCenter
            height: 40
            width: Theme.componentBorderWidth
            color: Theme.colorHeaderHighlight
            visible: (menuMain.visible)
        }

        Row {
            id: menuMain

            DesktopHeaderItem {
                id: menuMainView
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight
                highlightMode: "background"
                text: "Noeuds"

                selected: (appContent.state === "MainView")
                source: "qrc:/assets/icons_material/duotone-touch_app-24px.svg"
                onClicked: mainButtonClicked()
            }
            DesktopHeaderItem {
                id: menuStore
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight
                highlightMode: "background"
                text: "Magasin"

                selected: (appContent.state === "StoreView")
                source: "qrc:/assets/icons/svg/store-24-hour.svg"
                onClicked: storeButtonClicked()
            }
            DesktopHeaderItem {
                id: menuOrders
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight
                highlightMode: "background"
                text: "Commande"

                selected: (appContent.state === "OrderView")
                source: "qrc:/assets/icons/svg/store-24-hour.svg"
                onClicked: orderButtonClicked()
            }
            DesktopHeaderItem {
                id: menuGarage
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight
                highlightMode: "background"
                text: "Garage"

                selected: (appContent.state === "GarageView")
                source: "qrc:/assets/icons/svg/store-24-hour.svg"
                onClicked: garageButtonClicked()
            }
            DesktopHeaderItem {
                id: menuDelivery
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight
                highlightMode: "background"
                text: "Livraisons"

                selected: (appContent.state === "DeliveryView")
                source: "qrc:/assets/icons/svg/store-24-hour.svg"
                onClicked: deliveryButtonClicked()
            }
            DesktopHeaderItem {
                id: menuSettings
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight
                highlightMode: "background"

                selected: (appContent.state === "Settings")
                source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
                onClicked: settingsButtonClicked()
            }
            DesktopHeaderItem {
                id: menuAbout
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight
                highlightMode: "background"

                selected: (appContent.state === "About")
                source: "qrc:/assets/icons_material/outline-info-24px.svg"
                onClicked: aboutButtonClicked()
            }
            DesktopHeaderItem {
                id: quitApp
                height: header.height

                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight
                highlightMode: "background"

                source: "qrc:/assets/icons_material/duotone-exit_to_app-24px.svg"
                onClicked: utilsApp.appExit()
            }
        }
    }

    ////////////

    CsdWindows { }

    CsdLinux { }

    ////////////

    Rectangle { // separator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: !headerUnicolor
        height: 2
        opacity: 0.5
        color: Theme.colorHeaderHighlight
/*
        Rectangle { // shadow
            anchors.top: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            height: 8
            opacity: 0.66

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.colorHeaderHighlight; }
                GradientStop { position: 1.0; color: Theme.colorBackground; }
            }
        }
*/
    }
}
