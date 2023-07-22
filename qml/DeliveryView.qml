import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material

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

    function inspect(deliveryAlgorithm, algorithParams) {
        deliveryView.isRunning = true
        deliveryView.dataset = null
        let endpointAPI;
        if(deliveryAlgorithm === $Constants._ALGO_GENETIC) {
            deliveryView.algoName = "Algo Génétique"
            endpointAPI = '/genetic'
        } else if(deliveryAlgorithm === $Constants._ALGO_RECUIT) {
            deliveryView.algoName = "Recuit simulé"
            endpointAPI = '/recuit'
        } else if(deliveryAlgorithm === $Constants._ALGO_TABU) {
            deliveryView.algoName = "Recherche Tabou"
            endpointAPI = '/tabu'
        } else {
            deliveryView.algoName = "ERREUR"
            return
        }

        console.log(JSON.stringify(algorithParams))

        let data = {
            algo_params: algorithParams,
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

    TabBar {
        id: algoBar
        width:  500
        anchors.top: parent.top
        anchors.topMargin: 20
        enabled: !isRunning
        Material.background: Theme.colorPrimary


        Material.foreground: Material.color(Material.Grey,
                                            Material.Shade50)
        Material.accent: Material.color(Material.Grey, Material.Shade200)

        TabButton {
           text: qsTr("Recuit simulé")
           background: Rectangle {
               color: algoBar.currentIndex === 0 ? Theme.colorPrimary : $Colors.gray100
           }
           Material.foreground: Material.color(Material.Grey,
                                               Material.Shade900)
        }

        TabButton {
           text: qsTr("Génétique")
           background: Rectangle {
               color: algoBar.currentIndex === 1 ? Theme.colorPrimary : $Colors.gray100
           }
           Material.foreground: Material.color(Material.Grey,
                                               Material.Shade900)
        }

        TabButton {
           text: qsTr("Tabou")
           background: Rectangle {
               color: algoBar.currentIndex === 2 ? Theme.colorPrimary : $Colors.gray100
           }
           Material.foreground: Material.color(Material.Grey,
                                               Material.Shade900)
        }

    }

    StackLayout {
        id: head
        height: 200
        currentIndex: algoBar.currentIndex
        anchors {
            top: algoBar.bottom
            topMargin: 20

            left: parent.left
            right: parent.right
            margins: 20
        }
        enabled: !isRunning

        Item {
            id: recuitTab
            Column {
                width: parent.width - 20
                spacing: 10

                Label {
                    text: "Recuit simulé"
                    font {
                        pixelSize: 24
                        weight: Font.DemiBold
                    }
                }

                Flow {
                    width: parent.width
                    spacing: 10

                    AndroidTextField {
                        id: recuitTemp
                        title: "Température"
                        width: 300
                        text: "10"
                        validator: DoubleValidator {
                            bottom: 1
                        }
                    }


                    AndroidTextField {
                        id: recuitReductor
                        title: "Réducteur"
                        width: 300
                        text: "0,99"
                        validator: DoubleValidator {
                            bottom: 0.01
                            top: 0.999999999
                        }
                    }

                    AndroidTextField {
                        id: recuitAdmissionProba
                        title: "Probabilité d'admission"
                        width: 300
                        text: "0,51"
                        validator: DoubleValidator {
                            bottom: 0.001
                            top: 1
                        }
                    }

                    AndroidButtonIcon {
                        text: "Lancer le recuit simulé"
                        source: "qrc:/assets/icons/svg/content-save-plus.svg"
                        onClicked: {
                            inspect($Constants._ALGO_RECUIT, {
                                                                       temp: parseInt(recuitTemp.text.replace(",", ".")),
                                                                       reductor: parseFloat(recuitReductor.text.replace(",", ".")),
                                                                       proba_admission: parseFloat(recuitAdmissionProba.text.replace(",", "."))
                                                                       })
                        }

                        primaryColor: "white"
                        bgColor: Theme.colorPrimary
                    }
                }
            }

        }

        Item {
            id: geneticTab
            Column {
                width: parent.width - 20
                spacing: 10

                Label {
                    text: "Génétique"
                    font {
                        pixelSize: 24
                        weight: Font.DemiBold
                    }
                }

                Flow {
                    width: parent.width
                    spacing: 10

                    AndroidTextField {
                        id: genCount
                        title: "Nombre de générations"
                        width: 300
                        text: "10"
                        validator: IntValidator {
                            bottom: 1
                        }
                    }


                    AndroidTextField {
                        id: genMaxSelection
                        title: "Sélection max dans la génération"
                        width: 300
                        text: "70"
                        validator: IntValidator {
                            bottom: 1
                        }
                    }

                    AndroidTextField {
                        id: genMutationProbability
                        title: "Probabilité de mutation"
                        width: 300
                        text: "0,3"
                        validator: DoubleValidator {
                            bottom: 0.01
                            top: 1
                        }
                    }

                    AndroidButtonIcon {
                        text: "Lancer l'algo génétique"
                        source: "qrc:/assets/icons/svg/content-save-plus.svg"
                        onClicked: inspect($Constants._ALGO_GENETIC, {
                                           nb_generations: parseInt(genCount.text.replace(",", ".")),
                                           gen_max_selection: parseInt(genMaxSelection.text.replace(",", ".")),
                                           proba_mutation: parseFloat(genMutationProbability.text.replace(",", "."))
                                           })
                        primaryColor: "white"
                        bgColor: Theme.colorPrimary
                    }
                }
            }

        }

        Item {
            id: tabuTab
            Column {
                width: parent.width - 20
                spacing: 10

                Label {
                    text: "Recherche tabou"
                    font {
                        pixelSize: 24
                        weight: Font.DemiBold
                    }
                }

                Flow {
                    width: parent.width
                    spacing: 10

                    AndroidTextField {
                        id: tabuIterCount
                        title: "Nombre d'itérations"
                        width: 300
                        text: "10"
                        validator: IntValidator {
                            bottom: 1
                        }
                    }


                    AndroidTextField {
                        id: tabuMaxTabuSize
                        title: "Taille maximale de la liste Tabou"
                        width: 300
                        text: "20"
                        validator: IntValidator {
                            bottom: 1
                        }
                    }

                    AndroidTextField {
                        id: tabuOutAtTime
                        title: "Nombre de sorties simultannées"
                        width: 300
                        text: "1"
                        validator: IntValidator {
                            bottom: 1
                        }
                    }

                    AndroidButtonIcon {
                        text: "Lancer la recherche tabou"
                        source: "qrc:/assets/icons/svg/content-save-plus.svg"
                        onClicked: inspect($Constants._ALGO_TABU, {
                                           max_iter: parseInt(tabuIterCount.text.replace(",", ".")),
                                           max_tabu_list_size: parseInt(tabuMaxTabuSize.text.replace(",", ".")),
                                           nb_out_at_time: parseInt(tabuOutAtTime.text.replace(",", "."))
                                           })
                        primaryColor: "white"
                        bgColor: Theme.colorPrimary
                    }
                }
            }

        }

    }

    Loader {
        active: dataset !== null
        anchors {
            top: head.bottom

            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 10
            leftMargin: 70
        }


        sourceComponent: ScrollView {
            anchors.fill: parent
            contentHeight: generalDetailsArea.height + 300
            contentWidth: parent.width
            Column {
                id: generalDetailsArea
                spacing: 10
                width: deliveryView.width - 40

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
                        text: formatThousands(dataset.distance.toFixed(2)) + " km"
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

                Repeater {
                    id: travelListView
                    width: parent.width
                    model: Object.keys(dataset.trajet)
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
                                vehiculeUsedSize.value = 0
                                console.log("\n For vehicule ", modelData)
                                for (let idx = 0; idx < vehiculeTravel.length; idx++) {
                                    let node = JSON.parse(vehiculeTravel[idx])
                                    text += node?.name + ( screenSettings.displayPayload ? ` (${node.mvt?? 0})` : "") + (idx+1 === vehiculeTravel.length ? "" : " - ")
                                    if(node.mvt > 0) {
                                        console.log(vehiculeUsedSize.value, " -> ", node.mvt)
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

                        Item {
                            height: 300
                            width: 1
                            visible: index === (travelListView.model.length-1)
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
}
