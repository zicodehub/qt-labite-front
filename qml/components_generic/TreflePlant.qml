import QtQuick 2.15
import QtQuick.Controls
import ThemeEngine
import QtQuick.Layouts

import "qrc:/js/Http.js" as Http
import "qrc:/js/UtilsObject.js" as UtilsObject

Rectangle {
    id: control
    required property int trefleID
    required property int associatedTrefleID
    required property bool isChecked

    property bool isLoading: false

    property var specie: null

    signal setEquivalent
    signal unsetEquivalent

    readonly property color textColor: isChecked ? $Colors.white : $Colors.black
    property var updateData: function () {
        isLoading = true
        return new Promise(function (resolve, reject) {
            Http.retrieveTrefleSpecie(trefleID).then(function (response) {
                const jsonResponse = JSON.parse(response)
                const data = jsonResponse.data
                const meta = jsonResponse.meta
                specie = UtilsObject.replaceNullWithEmptyString(data)
                isLoading = false
                resolve(data)
            }).catch(function (err) {
                console.log("err ", err, JSON.stringify(err))
                isLoading = false
                if (err.status === 0) {
                    screenMainView.displayNotification(
                                "Echec, vérifiez votre connexion internet !")
                } else {
                    screenMainView.displayNotification(
                                "Une erreur inatendue s'est produite !")
                }

                reject(err)
            })
        })
    }

    Component.onCompleted: updateData()

    radius: 10
    color: isChecked ? $Colors.green500 : $Colors.gray300

    Column {
        width: parent.width - 20
        padding: 10

        RowLayout {
            visible: !isLoading
            width: parent.width
            spacing: 15

            Rectangle {
                Layout.preferredHeight: 30
                Layout.preferredWidth: Layout.preferredHeight
                radius: Layout.preferredHeight / 2
                color: !control.enabled ? $Colors.gray200 : isChecked ? Theme.colorPrimary : $Colors.white
                border {
                    width: 1
                    color: $Colors.gray600
                }
                Layout.alignment: Qt.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: !isChecked ? setEquivalent() : unsetEquivalent()
                }
            }

            ClipRect {
                Layout.preferredHeight: control.height - 20
                Layout.preferredWidth: Layout.preferredHeight
                radius: Layout.preferredHeight / 2
                Layout.alignment: Qt.AlignVCenter
                Rectangle {
                    anchors.fill: parent
                    color: specie?.image_url ? $Colors.gray100 : $Colors.red500
                }
                Image {
                    anchors.fill: parent
                    source: specie?.image_url ?? ""
                    cache: true
                }
            }

            Column {
                Layout.alignment: Qt.AlignVCenter
                padding: 10
                Label {
                    text: specie?.scientific_name ?? ""
                    font.pixelSize: 16
                    color: textColor
                }
                Label {
                    text: specie?.common_name ?? ""
                    font.pixelSize: 13
                    color: textColor
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Label {
                visible: Object.keys(specie?.images?? []).length > 0
                Layout.alignment: Qt.AlignVCenter
                text: Object.keys(specie?.images?? []).length + " images"
                font.pixelSize: 13
                color: textColor
            }
        }

    }

    BusyIndicator {
        running: isLoading
        anchors.centerIn: parent
    }
}
