import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

import ThemeEngine 1.0
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsObject.js" as UtilsObject
import "qrc:/js/Http.js" as Http
import "components_generic"

ClipRect {
    id: detailsBoard
    property var statusPlant: ({})
    property bool isSubmitting: false

    property bool overrideCheckboxStatus: false
    property bool collectivieCheckboxStatus: false

    radius: 20
    clip: true

    property var loadLocalDetails: function () {
        console.log("Loading local details...")
        detailsSpinner.running = true
        tm.start()
    }

    Rectangle {
        anchors.fill: parent
        color: $Colors.gray50
    }

    Timer {
        id: tm
        interval: 3000
        onTriggered: detailsSpinner.running = false
    }

    ScrollView {
        anchors.fill: parent
        contentHeight: _detailsCol.height
        contentWidth: parent.width - 20

        Column {
            id: _detailsCol
            width: parent.width
            spacing: 10
            ClipRect {
                height: 300
                width: 300
                radius: height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    anchors.fill: parent
                    color: $Colors.gray100
                }
                Image {
                    anchors.fill: parent
                    source: Http.getAssetURL(selectedPlant?.images_plantes.get(
                                                 0)?.directus_files_id)
                }
            }
            ButtonWireframeIcon {
                text: detailsBoard.statusPlant.label
                fullColor: true
                fulltextColor: $Colors.white
                primaryColor: {
                    if (detailsBoard.statusPlant.type === $Constants._PLANT_TYPE_ONE_EQUIV)
                        return $Colors.green700
                    if (detailsBoard.statusPlant.type === $Constants._PLANT_TYPE_NO_EQUIV)
                        return $Colors.red400
                    if (detailsBoard.statusPlant.type === $Constants._PLANT_TYPE_MULTI_EQUIV)
                        return $Colors.orange600
                    if (detailsBoard.statusPlant.type === $Constants._PLANT_TYPE_UNKNOWED)
                        return $Colors.red500
                }
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: selectedPlant?.name_scientific ?? ""
                font.pixelSize: 24
                font.weight: Font.DemiBold
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                width: parent.width - 20
                leftPadding: 10
                rightPadding: 10
                spacing: 2

                Repeater {
                    id: equivalentsListView
                    width: parent.width
                    //                    height: model ? model.length * 80 : 0
                    //                    clip: true
                    //                    spacing: 2
                    //                    footer: Item {
                    //                        height: 150
                    //                    }
                    model: control.selectedPlant?.str_trefle_ids?.split(
                               ",")?.map(x => parseInt(x.trim()))?.filter(
                               x => x > 0)
                    delegate: TreflePlant {
                        id: treflePlant
                        required property var modelData
                        required property int index
                        associatedTrefleID: selectedPlant?.trefle_id
                        trefleID: modelData
                        isChecked: detailsBoard.overrideCheckboxStatus ? detailsBoard.collectivieCheckboxStatus : modelData === selectedPlant?.trefle_id

                        width: parent.width
                        height: 80

                        onSetEquivalent: {
                            detailsBoard.collectivieCheckboxStatus = false
                            detailsBoard.overrideCheckboxStatus = true
                            equivalentsListView.enabled = false
                            detailsSpinner.running = true

                            Http.setPlantEquivalent(selectedPlant.id,
                                                    trefleID).then(
                                        function (response) {
                                            detailsSpinner.running = false
                                            console.log("Nothing will happen because Directus return 'No content for success updates")
                                        }).catch(function (err) {
                                            detailsSpinner.running = false
                                            if (err.status === 204) {
                                                selectedPlant.trefle_id = modelData
                                                detailsBoard.collectivieCheckboxStatus = false
                                                detailsBoard.overrideCheckboxStatus = false
                                                equivalentsListView.enabled = true
                                            } else {
                                                if (err.status === 0) {
                                                    screenMainView.displayNotification(
                                                                "Echec, veuillez vérifier votre connexion internet puis reéssayez !!")
                                                } else {
                                                    screenMainView.displayNotification(
                                                                "Une erreur inatendue s'est produite !")
                                                }
                                            }
                                        })
                        }
                        onUnsetEquivalent: {
                            detailsBoard.collectivieCheckboxStatus = false
                            detailsBoard.overrideCheckboxStatus = true
                            equivalentsListView.enabled = false
                            detailsSpinner.running = true

                            Http.setPlantEquivalent(selectedPlant.id,
                                                    null).then(
                                        function (response) {
                                            detailsSpinner.running = false
                                            console.log("Nothing will happen because Directus return 'No content for success updates")
                                        }).catch(function (err) {
                                            detailsSpinner.running = false
                                            if (err.status === 204) {
                                                selectedPlant.trefle_id = null
                                                detailsBoard.collectivieCheckboxStatus = false
                                                detailsBoard.overrideCheckboxStatus = false
                                                equivalentsListView.enabled = true
                                            } else {
                                                if (err.status === 0) {
                                                    screenMainView.displayNotification(
                                                                "Echec, veuillez vérifier votre connexion internet puis reéssayez !!")
                                                } else {
                                                    screenMainView.displayNotification(
                                                                "Une erreur inatendue s'est produite !")
                                                }
                                            }
                                        })
                        }
                    }
                }
                Item {
                    height: 150
                    width: parent.width
                }
            }
        }
    }

    BusyIndicator {
        id: detailsSpinner
        running: false
        anchors.centerIn: parent
    }
}
