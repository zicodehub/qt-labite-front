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
    id: deliveryView
    background: Rectangle {
        color: Theme.colorBackground //$Colors.gray100
    }

    property var dataset: null
    property string algoName: ""
    property bool isRunning: false

    function inspect(deliveryAlgorithm) {
        deliveryView.isRunning = true
        deliveryView.dataset = null
        let endpointAPI;
        if(deliveryAlgorithm === $Constants._ALGO_GENETIC) {
            deliveryView.algoName = "Algo Génétique"
            endpointAPI = '/genetic'
        } else if(deliveryAlgorithm === $Constants._ALGO_RECUIT) {
            deliveryView.algoName = "Recuit simulé"
            endpointAPI = '/recuit'
        } else {
            deliveryView.algoName = "ERREUR"
            return
        }

        let data = {
            clients: $Models.clients.model.all().map(item => { delete item['_model']; return item } ),
            suppliers: $Models.suppliers.model.all().map(item => { delete item['_model']; return item } ),
            type_articles: $Models.typeArticles.model.all().map(item => { delete item['_model']; return item } ),
            articles: $Models.articles.model.all().map(item => { delete item['_model']; return {id: item.id, name: item.name, type_article_id: item.type_article} } ),
            orders: $Models.orders.model.all().map(function(item) {
                delete item['_model'];
                return {id: item.id, name: item.name, qty_fixed: item.qty_fixed, client_id: item.client, supplier_id: item.supplier, article_id: item.article}
            } ),
            warehouses: $Models.warehouses.model.all().map(item => { delete item['_model']; return item } ),
            vehicules: $Models.vehicules.model.all().map(item => {
                                                             delete item['_model'];
                                                             return {
                                                                 id: item.id,
                                                                 warehouse_id: item.warehouse,
                                                                 size_compartment: item.size_compartment,
                                                                 nb_compartments: item.nb_compartments,
                                                                 cost: item.cost}

                                                         } ),
        }
        console.log("\n Gonna request ", screenSettings.serverURL+ endpointAPI)

        Http.request("POST",  screenSettings.serverURL+ endpointAPI, data)
        .then(function (response) {
            dataset = JSON.parse(response)
            deliveryView.isRunning = false
        })
        .catch(function (e) {
            console.log("AN ERROR ", e)
            deliveryView.isRunning = false
        })
    }

    function formatDuration (sec_num) {
        var hours   = Math.floor(sec_num / 3600);
        var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
        var seconds = sec_num - (hours * 3600) - (minutes * 60);

        if (hours   < 10) {hours   = "0"+hours;}
        if (minutes < 10) {minutes = "0"+minutes;}
        if (seconds < 10) {seconds = "0"+seconds;}
        return hours+'h '+minutes+'m '+seconds+' s';
    }

    function formatThousands(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    }

    RowLayout {
        id: head
        width: parent.width - 20
        anchors.top: parent.top
        anchors.topMargin: 20

        AndroidButtonIcon {
            text: "Recuit simulé"
            source: "qrc:/assets/icons/svg/content-save-plus.svg"
            onClicked: inspect($Constants._ALGO_RECUIT)
            enabled: !isRunning
        }

        Label {
            text: deliveryView.algoName
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font {
                pixelSize: 24
                weight: Font.Light
            }
        }

        Item {
            Layout.fillWidth: true
        }

        AndroidButtonIcon {
            text: "Génétique"
            source: "qrc:/assets/icons/svg/content-save-plus.svg"
            onClicked: inspect($Constants._ALGO_GENETIC)
            enabled: !isRunning
        }

    }

    Loader {
        active: dataset !== null
        anchors {
            top: head.bottom
            topMargin: 30

            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 10
            leftMargin: 70
        }


        sourceComponent: Item {
            width: parent.width
            Column {
                id: generalDetailsArea
                spacing: 10
                width: deliveryView.width - 40

//                width: parent.width

                Row {
                    width: parent.width
                    Label {
                        width: 200
                        text: "Durée: "
                        font {
                            pixelSize: 16
                            weight: Font.Light
                        }
                    }
                    TextEdit{
                        readOnly: true
                        leftPadding: 10
                        selectByMouse: true
                        selectByKeyboard: true
                        text: formatDuration(dataset.duration_seconds)
                        font {
                            pixelSize: 16
                            weight: Font.Bold
                        }
                    }
                }

                Row {
                    width: parent.width
                    Label {
                        width: 200
                        text: "Distance totale: "
                        font {
                            pixelSize: 16
                            weight: Font.Light
                        }
                    }
                    TextEdit {
                        readOnly: true
                        leftPadding: 10
                        selectByMouse: true
                        selectByKeyboard: true
                        text: formatThousands(parseInt(dataset.distance/1000)) + " km"
                        font {
                            pixelSize: 16
                            weight: Font.Bold
                        }
                    }
                }

                Row {
                    width: parent.width
                    Label {
                        width: 200
                        text: "Cout total: "
                        font {
                            pixelSize: 16
                            weight: Font.Light
                        }
                    }
                    TextEdit {
                        readOnly: true
                        leftPadding: 10
                        selectByMouse: true
                        selectByKeyboard: true
                        text: formatThousands(parseInt(dataset.cout))
                        font {
                            pixelSize: 16
                            weight: Font.Bold
                        }
                    }
                }

                Row {
                    width: parent.width
                    Label {
                        width: 200
                        text: "Chemin solution: "
                        font {
                            pixelSize: 16
                            weight: Font.Light
                        }
                    }
                    TextEdit {
                        width: deliveryView.width / 2
                        readOnly: true
                        leftPadding: 10
                        selectByMouse: true
                        selectByKeyboard: true
                        wrapMode: Text.Wrap
                        text: dataset.short.join(' - ')
                        font {
                            pixelSize: 16
                            weight: Font.Bold
                        }
                    }
                }


                Row {
                    width: parent.width
                    Label {
                        width: 200
                        text: "Nombre de véhicule utilisés: "
                        font {
                            pixelSize: 16
                            weight: Font.Light
                        }
                    }
                    TextEdit {
                        readOnly: true
                        leftPadding: 10
                        selectByMouse: true
                        selectByKeyboard: true
                        text: Object.values(dataset.trajet).filter(function (route) { return route.length > 0 }).length + " véhicules"
                        font {
                            pixelSize: 16
                            weight: Font.Bold
                        }
                    }
                }


                Row {
                    width: parent.width
                    Label {
                        width: 200
                        text: "Véhicule utilisés: "
                        font {
                            pixelSize: 16
                            weight: Font.Light
                        }
                    }
                    TextEdit {
                        readOnly: true
                        leftPadding: 10
                        selectByMouse: true
                        selectByKeyboard: true
                        width: deliveryView.width / 1.5
                        wrapMode: Text.Wrap
                        text: Object.keys(dataset.trajet).filter(function (route) { return dataset.trajet[route].length > 0 }).join(' - ') //Object.keys(dataset.trajet).join(' - ')
                        font {
                            pixelSize: 16
                            weight: Font.Bold
                        }
                    }
                }

            }

            ListView {
                id: travelListView
                anchors.top: generalDetailsArea.bottom
                anchors.topMargin: 30
                width: parent.width
                height: 400

                clip: true
                model: Object.keys(dataset.trajet)
                spacing: 20
                delegate: Column {
                    required property var modelData
                    required property int index
                    property var vehiculeData: dataset["vehicules"][modelData]

                    width: travelListView.width
                    spacing: 2


                    Row {
                        spacing: 5
                        Label {
                            text: modelData
                            font {
                                pixelSize: 24
                                weight: Font.Bold
                            }
                            color: Theme.colorPrimary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Label {
                            visible: !screenSettings.displayPayload
                            id: vehiculeTotalSize
                            text: "(Total " + (vehiculeData.nb_compartments * vehiculeData.size_compartment) + ")"
                            font {
                                pixelSize: 16
                            }
                            color: Theme.colorPrimary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Label {
                            visible: !screenSettings.displayPayload
                            id: vehiculeUsedSize
                            property int value: 0
                            text: "(Transporté " + value + ")"
                            font {
                                pixelSize: 16
                            }
                            color: Theme.colorPrimary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    TextEdit {
                        id: vehiculeTravelText
                        property int suppliersHolding: 0
                        width: parent.width - 50
                        wrapMode: Text.Wrap
                        readOnly: true
                        leftPadding: 10
                        selectByMouse: true
                        selectByKeyboard: true
                        text: node?.name + ( screenSettings.displayPayload ? ` (${node.mvt?? 0})` : "") + " - "
                        font {
                            weight: Font.DemiBold
                            pixelSize: 16
                        }
                        function updateTravel() {
                            text = ""
                            let vehiculeTravel = dataset.trajet[modelData]
                            for (let idx = 0; idx < vehiculeTravel.length; idx++) {
                                let node = JSON.parse(vehiculeTravel[idx])
                                text += node?.name + ( screenSettings.displayPayload ? ` (${node.mvt?? 0})` : "") + (idx+1 === vehiculeTravel.length ? "" : " - ")
                                if(node.mvt > 0) {
                                    vehiculeUsedSize.value += node.mvt
                                }
                            }

                        }
                        Connections {
                            target: screenSettings
                            function onDisplayPayloadChanged () {
                                vehiculeTravelText.updateTravel()
                            }
                        }

                        Component.onCompleted: updateTravel()
                    }

//                    Flow {
//                        width: parent.width
//                        spacing: 5

//                        Repeater {
//                            model: dataset.trajet[modelData]
//                            TextEdit {
//                                required property var modelData
//                                property var node: JSON.parse(modelData)
//                                readOnly: true
//                                selectByMouse: true
//                                selectByKeyboard: true
//                                text: node?.name + ( screenSettings.displayPayload ? ` (${node.mvt?? 0})` : "") + " - "
//                                font {
//                                    weight: Font.DemiBold
//                                    pixelSize: 14
//                                }
//                                Component.onCompleted: {
//                                    if(node.mvt > 0) {
//                                        vehiculeUsedSize.value += node.mvt
//                                    }
//                                }
//                            }
//                        }

//                    }

                }
            }



        }
    }
}
