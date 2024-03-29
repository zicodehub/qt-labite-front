import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

import ThemeEngine 1.0
import "qrc:/js/UtilsNumber.js" as UtilsNumber
import "qrc:/js/Http.js" as Http
import "components_generic"

Item {
    id: settingsScreen
    width: 480
    height: 720
    anchors.fill: parent


    property alias serverURL: _serverURL.text
    property alias displayPayload: switchPayload.checked
    property alias nodeSize: _nodeSize.text
    ////////////////////////////////////////////////////////////////////////////

    Drawer {
        id: confirmDeleteDrawer
        edge: Qt.LeftEdge
        dim: true
        modal: true
        interactive: true
        width: parent.width/1.5
        height: parent.height
        padding: 20

        Item {
            anchors.fill: parent
            anchors.margins: 20
            ColumnLayout {
                width: parent.width - 2*parent.padding
                height: parent.height
                Item {
                    Layout.fillHeight: true
                }
                Label {
                    text: "Voulez-vous vraiment éffacer toutes les données de l'application ? Les noeuds, commandes, articles, véhicules, ... seront définitivement supprimés"
                }
                Item {
                    Layout.fillHeight: true
                }
                RowLayout {
                    width: parent.width
                    AndroidButtonIcon {
                        text: "Je veux tout supprimer"
                        source: 'qrc:/assets/icons/svg/delete-forever-outline.svg'
                        primaryColor: $Colors.white
                        backgroundItem.color: $Colors.red400
                        onClicked: {
                            $Models.orders.sqlRemoveAll()
                            $Models.vehicules.sqlRemoveAll()
                            $Models.warehouses.sqlRemoveAll()
                            $Models.articles.sqlRemoveAll()
                            $Models.typeArticles.sqlRemoveAll()
                            $Models.clients.sqlRemoveAll()
                            $Models.suppliers.sqlRemoveAll()
                            confirmDeleteDrawer.close()
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    AndroidButtonIcon {
                        text: "Annuler"
                        onClicked: confirmDeleteDrawer.close()
                    }
                }
            }
        }


    }

    Drawer {
        id: confirmResetDB
        edge: Qt.LeftEdge
        dim: true
        modal: true
        interactive: true
        width: parent.width/1.5
        height: parent.height
        padding: 20

        Item {
            anchors.fill: parent
            anchors.margins: 20
            ColumnLayout {
                width: parent.width - 2*parent.padding
                height: parent.height
                Item {
                    Layout.fillHeight: true
                }
                Label {
                    text: "Toutes toutes les données seront éffacer et la base sera reconstruite"
                    font.pixelSize: 24
                }
                Item {
                    Layout.fillHeight: true
                }
                RowLayout {
                    width: parent.width
                    AndroidButtonIcon {
                        text: "Je veux reconstruire la base"
                        source: 'qrc:/assets/icons/svg/delete-forever-outline.svg'
                        primaryColor: $Colors.white
                        backgroundItem.color: $Colors.red400
                        onClicked: {
                            $Models.orders.sqlRemoveAll()
                            $Models.vehicules.sqlRemoveAll()
                            $Models.warehouses.sqlRemoveAll()
                            $Models.articles.sqlRemoveAll()
                            $Models.typeArticles.sqlRemoveAll()
                            $Models.clients.sqlRemoveAll()
                            $Models.suppliers.sqlRemoveAll()

                            // Wipe BD
                            $Models.loseAndChangeDB()

                            confirmResetDB.close()
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    AndroidButtonIcon {
                        text: "Annuler"
                        onClicked: confirmDeleteDrawer.close()
                    }
                }
            }
        }


    }

    Flickable {
        anchors.fill: parent
        contentWidth: -1
        contentHeight: column.height

        boundsBehavior: isDesktop ? Flickable.OvershootBounds : Flickable.DragAndOvershootBounds
        ScrollBar.vertical: ScrollBar { visible: isDesktop; }

        Column {
            id: column
            anchors.left: parent.left
            anchors.right: parent.right
            anchors {
                leftMargin: 20
                rightMargin: 20
            }

            topPadding: 12
            bottomPadding: 12
            spacing: 8

            ////////////////

            Rectangle {
                height: 48
                anchors.left: parent.left
                anchors.right: parent.right

                color: Theme.colorForeground

                IconSvg {
                    id: image_appsettings
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenPaddingLeft + 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
                }

                Text {
                    id: text_appsettings
                    anchors.left: image_appsettings.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Application")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    font.bold: false
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ////////////////

            Item {
                id: element_appTheme
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                IconSvg {
                    id: image_appTheme
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons_material/duotone-style-24px.svg"
                }

                Text {
                    id: text_appTheme
                    height: 40
                    anchors.left: image_appTheme.right
                    anchors.leftMargin: 24
                    anchors.right: appTheme_selector.left
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Theme")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                Row {
                    id: appTheme_selector
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    z: 1
                    spacing: 10

                    Rectangle {
                        id: rectangleSnow
                        width: wideWideMode ? 80 : 32
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 2
                        color: "white"
                        border.color: (settingsManager.appTheme === "THEME_SNOW") ? Theme.colorSubText : "#ccc"
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            visible: wideWideMode
                            text: qsTr("snow")
                            textFormat: Text.PlainText
                            color: (settingsManager.appTheme === "THEME_SNOW") ? Theme.colorSubText : "#ccc"
                            font.bold: true
                            font.pixelSize: Theme.fontSizeContentSmall
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: settingsManager.appTheme = "THEME_SNOW"
                        }
                    }
                    Rectangle {
                        id: rectangleGreen
                        width: wideWideMode ? 80 : 32
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 2
                        color: "#09debc" // green theme colorSecondary
                        border.color: Theme.colorPrimary
                        border.width: (settingsManager.appTheme === "THEME_PLANT") ? 2 : 0

                        Text {
                            anchors.centerIn: parent
                            visible: wideWideMode
                            text: qsTr("plant")
                            textFormat: Text.PlainText
                            color: "white"
                            font.bold: true
                            font.pixelSize: Theme.fontSizeContentSmall
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: settingsManager.appTheme = "THEME_PLANT"
                        }
                    }
                    Rectangle {
                        id: rectangleDay
                        width: wideWideMode ? 80 : 32
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 2
                        color: "#FFE400" // day theme colorSecondary
                        border.color: Theme.colorPrimary
                        border.width: (settingsManager.appTheme === "THEME_DAY") ? 2 : 0

                        Text {
                            anchors.centerIn: parent
                            visible: wideWideMode
                            text: qsTr("day")
                            textFormat: Text.PlainText
                            color: "white"
                            font.bold: true
                            font.pixelSize: Theme.fontSizeContentSmall
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: settingsManager.appTheme = "THEME_DAY"
                        }
                    }
                    Rectangle {
                        id: rectangleNight
                        width: wideWideMode ? 80 : 32
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 2
                        color: "#555151"
                        border.color: Theme.colorPrimary
                        border.width: (settingsManager.appTheme === "THEME_NIGHT") ? 2 : 0

                        Text {
                            anchors.centerIn: parent
                            visible: wideWideMode
                            text: qsTr("night")
                            textFormat: Text.PlainText
                            color: (settingsManager.appTheme === "THEME_NIGHT") ? Theme.colorPrimary : "#ececec"
                            font.bold: true
                            font.pixelSize: Theme.fontSizeContentSmall
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: settingsManager.appTheme = "THEME_NIGHT"
                        }
                    }
                }
            }

            Rectangle {
                height: 48
                anchors.left: parent.left
                anchors.right: parent.right

                color: Theme.colorForeground

                IconSvg {
                    id: _imgServer
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenPaddingLeft + 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: 'qrc:/assets/icons/svg/server-security.svg'
                }

                Text{
                    id: _middleText
                    anchors.left: _imgServer.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Adresse du server")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    font.bold: false
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    id: itemServerStatus
                    property bool working: false
                    property var checkStatus: function () {
                        console.log("\n\n CHECK STATUS \n\n")
                        visible = false
                        Http.request("GET",  screenSettings.serverURL)
                        .then(function (response) {
                            itemServerStatus.visible = true
                            JSON.parse(response)
                            itemServerStatus.working = true
                        })
                        .catch(function (e) {
                            itemServerStatus.visible = true
                            console.log("Error request ", e, JSON.stringify(e))
                            itemServerStatus.working = false
                        })
                    }
                    Component.onCompleted: checkStatus()

                    width: 40
                    height: width
                    radius: height/2
                    color: working ? $Colors.green600 : $Colors.red400
                    anchors.left: _middleText.right
                    anchors.leftMargin: 20

                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: parent.working ? "OK" : "NON"
                        anchors.centerIn: parent
                    }
                }


                TextArea {
                    id: _serverURL
                    text: "http://localhost:8080"

                    onTextChanged: btnUpdateServerAddress.clicked()

                    anchors.top: parent.top
                    anchors.topMargin: 7

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 7

                    anchors.left: itemServerStatus.right
                    anchors.leftMargin: 20

                    anchors.right: btnUpdateServerAddress.left
                    anchors.rightMargin: 30

                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter

                    font.pixelSize: 16
//                    validator: RegularExpressionValidator {
//                        regularExpression: /^(http:\/\/.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$/
//                    }
                }


                Button {
                    id: btnUpdateServerAddress
                    width: 120
                    text: "Vérifier le server"

                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: itemServerStatus.checkStatus()
                }
            }

            Rectangle {
                height: 48
                anchors.left: parent.left
                anchors.right: parent.right

                color: Theme.colorForeground

                IconSvg {
                    id: _imgNodeSize
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenPaddingLeft + 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: 'qrc:/assets/icons/svg/server-security.svg'
                }

                Text{
                    id: _labelNodeSize
                    anchors.left: _imgNodeSize.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Taille des noeuds")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    font.bold: false
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }


                TextField {
                    id: _nodeSize
                    text: "30"

//                    onTextChanged: btnUpdateServerAddress.clicked()

                    anchors.top: parent.top
                    anchors.topMargin: 7

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 7

                    anchors.left: _labelNodeSize.right
                    anchors.leftMargin: 20

                    anchors.right: parent.right
                    anchors.rightMargin: 30

                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter

                    font.pixelSize: 16
                    validator: IntValidator {
                        bottom: 10
                    }
                }

            }

            Item {
                id: elementDisplayNodePayload
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                IconSvg {
                    id: _imgPayload
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons_material/duotone-style-24px.svg"
                }

                Text {
                    id: textDisplayPayload
                    height: 40
                    anchors.left: _imgPayload.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Montrer les charges transportées")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedDesktop {id: switchPayload
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    text: "Switch"
                    checked: settingsScreen.displayPayload
                }
            }

            Rectangle {
                height: 68
                anchors.left: parent.left
                anchors.right: parent.right

                color: Theme.colorForeground

                IconSvg {
                    id: iconWipeData
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenPaddingLeft + 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: 'qrc:/assets/icons/svg/server-security.svg'
                }

                Text{
                    id: textWipeData
                    anchors.left: iconWipeData.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Supprimer toutes les données")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    font.bold: false
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                AndroidButtonIcon {
                    text: "Supprimer toutes données"
                    source: 'qrc:/assets/icons/svg/delete-forever-outline.svg'
                    primaryColor: $Colors.white
                    backgroundItem.color: $Colors.red400
                    anchors {
                        right: parent.right
                        rightMargin: 30

                        top: parent.top
                        bottom: parent.bottom
                        margins: 10
                    }
                    onClicked: {
                        confirmDeleteDrawer.open()
                    }
                }
            }

            Rectangle {
                height: 68
                anchors.left: parent.left
                anchors.right: parent.right

                color: Theme.colorForeground

                IconSvg {
                    id: iconResetDB
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenPaddingLeft + 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: 'qrc:/assets/icons/svg/server-security.svg'
                }

                Text{
                    id: textResetDB
                    anchors.left: iconResetDB.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("RECONSTRUIRE LA BASE")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    font.bold: false
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                AndroidButtonIcon {
                    text: "Reconstruire la base de données"
                    source: 'qrc:/assets/icons/svg/delete-forever-outline.svg'
                    primaryColor: $Colors.white
                    backgroundItem.color: $Colors.red400
                    anchors {
                        right: parent.right
                        rightMargin: 30

                        top: parent.top
                        bottom: parent.bottom
                        margins: 10
                    }
                    onClicked: {
                        confirmResetDB.open()
                    }
                }
            }

        }
    }
}
