import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

import ThemeEngine 1.0
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsObject.js" as UtilsObject
import "qrc:/js/Http.js" as Http
import "components_generic"
import "widgets"

Page {
    id: storeView
    background: Rectangle {
        color: $Colors.gray200
    }

    AddTypeArticle {
        id: addTypeArticleDrawer

        width: parent.width / 2.5
        height: parent.height
        edge: Qt.RightEdge
        dim: true
        modal: true
        interactive: true
    }

    AddArticle {
        id: addTArticleDrawer

        width: parent.width / 2.5
        height: parent.height
        edge: Qt.LeftEdge
        dim: true
        modal: true
        interactive: true
    }

    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 20
        ColumnLayout {
            Layout.preferredWidth: 150
            Layout.fillHeight: true

            RowLayout {
                Layout.fillWidth: true
                Item {
                    Layout.fillWidth: true
                }
                AndroidButtonIcon {
                    text: "Ajouter un type"
                    source: "qrc:/assets/icons/svg/content-save-plus.svg"
                    onClicked: addTypeArticleDrawer.open()
                }

            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 5

                model: $Models.typeArticle
                delegate: ItemDelegate {
                    required property var model
                    width: parent.width
                    height: 40

                    Label {
                        text: model.name
                        font.pixelSize: 24
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 10
                    }
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            color: Theme.colorPrimary
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                Layout.fillWidth: true
                Item {
                    Layout.fillWidth: true
                }
                AndroidButtonIcon {
                    text: "Ajouter un article"
                    source: "qrc:/assets/icons/svg/content-save-plus.svg"
                    onClicked: addTArticleDrawer.open()
                }

            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 5

                model: $Models.article
                delegate: ItemDelegate {
                    required property var model
                    width: parent.width
                    height: 40

                    Label {
                        text: model.name
                        font.pixelSize: 24
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 10
                    }
                }
            }
        }

    }
}
