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
    id: garageView
    background: Rectangle {
        color: $Colors.gray200
    }


    AddVehicule {
        id: addVehiculeDrawer

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
            Layout.preferredWidth: 100
            Layout.fillHeight: true

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                header: Label {
                    text: "Les dépots"
                }

                spacing: 5

                model: $Models.warehouses
                delegate: ItemDelegate {
                    required property var model
                    height: 40
                    width: parent.width

                    Label {
                        text: "D"+model.id
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
                    text: "Ajouter un véhicule"
                    source: "qrc:/assets/icons/svg/content-save-plus.svg"
                    onClicked: addVehiculeDrawer.open()
                }

            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 5

                model: $Models.vehicule
                delegate: ItemDelegate {
                    required property var model
                    width: parent.width
                    height: 40

                    Label {
                        text: "V"+model.id
                        font.pixelSize: 24
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 10
                    }
                }
            }
        }

    }
}
