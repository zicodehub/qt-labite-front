import QtQuick 2.15
import QtQuick.Controls 2.15

import ThemeEngine 1.0
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Item {
    id: aboutScreen
    width: 480
    height: 720
    anchors.fill: parent

    ////////////////////////////////////////////////////////////////////////////

    Flickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.height

        boundsBehavior: isDesktop ? Flickable.OvershootBounds : Flickable.DragAndOvershootBounds
        ScrollBar.vertical: ScrollBar { visible: isDesktop; }

        Column {
            id: column
            anchors.left: parent.left
            anchors.leftMargin: screenPaddingLeft + 16
            anchors.right: parent.right
            anchors.rightMargin: screenPaddingRight + 16

            topPadding: 0
            bottomPadding: 8
            spacing: 8

            ////////////////

            Rectangle { // header
                anchors.left: parent.left
                anchors.leftMargin: -(screenPaddingLeft + 16)
                anchors.right: parent.right
                anchors.rightMargin: -(screenPaddingRight + 16)

                height: 92
                color: Theme.colorForeground

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    z: 2
                    height: 92
                    spacing: 24

                    Image { // logo
                        width: 92
                        height: 92
                        anchors.verticalCenter: parent.verticalCenter

                        source: "qrc:/assets/logos/logo.svg"
                        sourceSize: Qt.size(width, height)
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 2
                        spacing: 0

                        Text {
                            text: "PDPTW - (pour Labité)"
                            color: Theme.colorText
                            font.pixelSize: 28
                        }
                        Text {
                            color: Theme.colorSubText
                            text: qsTr("version %1 %2").arg(utilsApp.appVersion()).arg(utilsApp.appBuildMode())
                            font.pixelSize: Theme.fontSizeContentBig
                        }
                    }
                }


            }

            ////////////////

            Row {
                id: buttonsRow
                height: 56

                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                visible: !wideWideMode
                spacing: 16

                ButtonWireframeIconCentered {
                    width: ((parent.width - 16) / 2)
                    anchors.verticalCenter: parent.verticalCenter

                    sourceSize: 28
                    fullColor: true
                    primaryColor: (Theme.currentTheme === ThemeEngine.THEME_NIGHT) ? Theme.colorHeader : "#5483EF"

                    text: qsTr("WEBSITE")
                    source: "qrc:/assets/icons_material/baseline-insert_link-24px.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/")
                }
                ButtonWireframeIconCentered {
                    width: ((parent.width - 16) / 2)
                    anchors.verticalCenter: parent.verticalCenter

                    sourceSize: 22
                    fullColor: true
                    primaryColor: (Theme.currentTheme === ThemeEngine.THEME_NIGHT) ? Theme.colorHeader : "#5483EF"

                    text: qsTr("SUPPORT")
                    source: "qrc:/assets/icons_material/baseline-support-24px.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/")
                }
            }

            ////////////////

            Item { height: 1; width: 1; visible: isDesktop; } // spacer

            Item {
                id: desc
                height: Math.max(UtilsNumber.alignTo(description.contentHeight, 8), 48)
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                IconSvg {
                    id: descImg
                    width: 32
                    height: 32
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    anchors.left: parent.left

                    source: "qrc:/assets/icons_material/outline-info-24px.svg"
                    color: Theme.colorIcon
                }

                Text {
                    id: description
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: desc.verticalCenter

                    text: qsTr("Cette application permet d'avoir une globale sur les plantes associées associées à l'application Blume !")
                    textFormat: Text.PlainText
                    wrapMode: Text.WordWrap
                    color: Theme.colorText
                    font.pixelSize: Theme.fontSizeContent
                }
            }

        }
    }
}
