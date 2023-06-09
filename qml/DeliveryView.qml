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
        color: $Colors.gray100
    }
    property var dataset: null
    property string algoName: ""
    property bool isRunning: false

    function inspect(_name) {
        deliveryView.isRunning = true
        deliveryView.algoName = _name
        let data = {
            clients: $Models.clients.model.all().map(item => { delete item['_model']; return item } ),
            suppliers: $Models.suppliers.model.all().map(item => { delete item['_model']; return item } ),
            type_articles: $Models.typeArticles.model.all().map(item => { delete item['_model']; return item } ),
            articles: $Models.articles.model.all().map(item => { delete item['_model']; return {name: item.name, type_article_id: item.type_article} } ),
            orders: $Models.orders.model.all().map(function(item) {
                delete item['_model'];
                return {name: item.name, qty_fixed: item.qty_fixed, client_id: item.client, supplier_id: item.supplier, article_id: item.article}
            } ),
            warehouses: $Models.warehouses.model.all().map(item => { delete item['_model']; return item } ),
            vehicules: $Models.vehicules.model.all().map(item => {
                                                             delete item['_model'];
                                                             return {
                                                                 warehouse_id: item.warehouse,
                                                                 size_compartment: item.size_compartment,
                                                                 nb_compartments: item.nb_compartments,
                                                                 cost: item.cost}

                                                         } ),
        }
        console.log("\n Gonna request")

        Http.request("POST", "http://localhost:8080/recuit", data)
        .then(function (response) {
            dataset = JSON.parse(response)
            deliveryView.isRunning = false
        })
        .catch(function (e) {
            console.log("AN ERROR ", e)
            deliveryView.isRunning = false
        })
    }

    RowLayout {
        id: head
        width: parent.width - 20
        anchors.top: parent.top
        anchors.topMargin: 20

        AndroidButtonIcon {
            text: "Recuit simulé"
            source: "qrc:/assets/icons/svg/content-save-plus.svg"
            onClicked: inspect("Recuit simulé")
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
            onClicked: inspect("Génétique")
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
        }


        sourceComponent: Item {
            width: parent.width
            Column {
                id: generalDetailsArea
                spacing: 7
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                width: deliveryView.width/2

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
                    Label {
                        text: dataset.duration
                        font {
                            pixelSize: 16
                            weight: Font.Light
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
                    Label {
                        text: dataset.distance+ "km"
                        font {
                            pixelSize: 16
                            weight: Font.Light
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
                    Label {
                        text: dataset.cout
                        font {
                            pixelSize: 16
                            weight: Font.Light
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
                    Label {
                        width: deliveryView.width / 2
                        wrapMode: Text.Wrap
                        text: dataset.short.join(' - ')
                        font {
                            pixelSize: 16
                            weight: Font.Light
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
                    Label {
                        text: Object.keys(dataset.trajet).length + " véhicules"
                        font {
                            pixelSize: 16
                            weight: Font.Light
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
                    Label {
                        width: deliveryView.width / 2
                        wrapMode: Text.Wrap
                        text: Object.keys(dataset.trajet).join(' - ')
                        font {
                            pixelSize: 16
                            weight: Font.Light
                        }
                    }
                }

            }

            ListView {
                id: travelListView
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    left: generalDetailsArea.right
                }

                clip: true
                model: Object.keys(dataset.trajet)
                spacing: 20
                delegate: Column {
                    required property var modelData
                    required property int index

                    width: parent.width
                    spacing: 5


                    Label {
                        text: modelData
                        font {
                            pixelSize: 18
                            weight: Font.Bold
                        }
                        color: Theme.colorPrimary
                    }

                    Flow {
                        width: parent.width
                        spacing: 5

                        Repeater {
                            model: dataset.trajet[modelData]
                            Rectangle {
                                required property var modelData
                                width: 30
                                height: width
                                radius: height/2
                                color: $Colors.black
                                Label {
                                    anchors.centerIn: parent
                                    text: JSON.parse(modelData)?.name
                                    font {
                                        weight: Font.Light
                                    }
                                    color: $Colors.white
                                }
                            }
                        }

                    }
                }
            }

        }
    }
}