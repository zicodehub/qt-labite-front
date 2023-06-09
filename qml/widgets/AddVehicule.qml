import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import ThemeEngine
import "qrc:/qml"

Drawer {
    id: control

    onClosed: {
        comboBoxNbCompartments.value = 50
        comboBoxSizeCompartments.value = 10
        comboBoxCostVehicule.value = 60
        if(comboBoxWarehouse.currentIndex > -1) {
            comboBoxWarehouse.currentIndex = 0
        }
    }

    Item {
        anchors.fill: parent
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Column {
                width: parent.width
                Label {
                    text: "Nombre de compartiments"
                }

                SpinBoxThemed {
                    id: comboBoxNbCompartments
                    width: 300
                    from: 0
                    to: 1000000
                }
            }

            Column {
                width: parent.width
                Label {
                    text: "Taille des compartiments"
                }

                SpinBoxThemed {
                    id: comboBoxSizeCompartments
                    width: 300
                    from: 0
                    to: 1000000
                }
            }

            Column {
                width: parent.width
                Label {
                    text: "Cout du véhicule"
                }

                SpinBoxThemed {
                    id: comboBoxCostVehicule
                    width: 300
                    from: 0
                    to: 1000000
                }
            }

            Column {
                width: parent.width
                Label {
                    text: "Dépot"
                }

                ComboBoxThemed {
                    id: comboBoxWarehouse
                    width: 300
                    model: $Models.warehouses
                    contentItem: Text {
                        text: (comboBoxWarehouse.currentIndex > -1 ? ("D" + comboBoxWarehouse?.model?.get(comboBoxWarehouse.currentIndex)?.id) : "")
                        textFormat: Text.PlainText

                        font: control.font
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter

                        color: Theme.colorComponentContent
                    }

                    delegate: ItemDelegate {
                        required property var model
                        required property int index

                        width: comboBoxWarehouse.width - 2
                        height: comboBoxWarehouse.height
                        highlighted: (comboBoxWarehouse.highlightedIndex === index)

                        background: Rectangle {
                            implicitWidth: 200
                            implicitHeight: Theme.componentHeight

                            radius: Theme.componentRadius
                            color: highlighted ? "#F6F6F6" : "white"
                        }

                        contentItem: Text {
                            leftPadding: comboBoxWarehouse.leftPadding
                            text: "D"+model.id
                            color: highlighted ? "black" : Theme.colorSubText
                            font.pixelSize: Theme.fontSizeComponent
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
            RowLayout {
                width: parent.width
                Item {
                    Layout.fillWidth: true
                }
                AndroidButtonIcon {
                    text: "Créer"
                    source: "qrc:/assets/icons/svg/content-save-plus.svg"
                    onClicked: {
                        comboBoxNbCompartments.focus = false
                        comboBoxSizeCompartments.focus = false
                        comboBoxCostVehicule.focus = false

                        console.log(JSON.stringify({
                                                       nb_compartments: comboBoxNbCompartments.value,
                                                       size_compartment: comboBoxSizeCompartments.value,
                                                       cost: comboBoxCostVehicule.value,
                                                       warehouse: comboBoxWarehouse.model.get(comboBoxWarehouse.currentIndex).id
                                                   }))
                        if(comboBoxNbCompartments.value > 0 && comboBoxSizeCompartments.value > 0 && comboBoxCostVehicule.value > 0 && comboBoxWarehouse.currentIndex > -1) {
                            let res = $Models.vehicules.sqlCreate({
                                                                     nb_compartments: comboBoxNbCompartments.value,
                                                                     size_compartment: comboBoxSizeCompartments.value,
                                                                     cost: comboBoxCostVehicule.value,
                                                                     warehouse: comboBoxWarehouse.model.get(comboBoxWarehouse.currentIndex).id
                                                                 })
                            if(res) control.close()

                        }

//                            comboBoxWarehouse.model.get(comboBoxWarehouse.currentIndex).id
//                        if(nameArticle.text !== "" && comboBoxAppTheme.currentIndex > -1) {
//                            console.log()
//                        }
                    }
                }
            }

        }
    }
}
