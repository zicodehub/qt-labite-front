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
    id: orderView

    property var itemEditIndex: null
    property bool isEditing: false
    property bool isFormValid: comboBoxSupplier.currentIndex > -1 && comboBoxClient.currentIndex > -1 && comboBoxArticle.currentIndex > -1 && qtyOrder.text != ""

    background: Rectangle {
        color: Theme.colorBackground //$Colors.gray100
    }

    leftPadding: 10
    rightPadding: 10

    function cleanForm() {
        qtyOrder.text = ""
        comboBoxSupplier.currentIndex = -1
        comboBoxClient.currentIndex = -1
        comboBoxArticle.currentIndex = -1
        orderView.isEditing = false
    }

    Column {
        id: header
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 30
        spacing: 10

        RowLayout {
            width: parent.width
            spacing: 10
            Label {
                text: ordersListView.model.count + " commandes"
                font.pixelSize: 24
                font.weight: Font.Light
            }

            Item {
                Layout.fillWidth: true
            }
            AndroidButtonIcon {
                text: "Créer une commande"
                source: "qrc:/assets/icons/svg/content-save-plus.svg"
                visible: !orderView.isEditing
                onClicked: {
                    orderView.isEditing = !orderView.isEditing
                }
            }
            AndroidButtonIcon {
                text: "Valider la commande"
                source: "qrc:/assets/icons/svg/content-save-plus.svg"
                visible: isFormValid
                onClicked: {
                    let data = {
                        client: comboBoxClient.currentValue,
                        supplier: comboBoxSupplier.currentValue,
                        article: comboBoxArticle.currentValue,
                        qty_fixed: parseInt(qtyOrder.text)
                    }


                    let order = $Models.orders.sqlCreate(data)
                    orderView.cleanForm()
                }
            }
        }
    }

    RowLayout {
        id: editArea
        visible: orderView.isEditing
        width: parent.width
        height: 50
        anchors.top: header.bottom
        anchors.topMargin: 30
        spacing: 0

        IconSvg {
            Layout.preferredWidth: 30
            Layout.preferredHeight: Layout.preferredWidth
            source: 'qrc:/assets/icons/svg/delete-forever.svg'
            color: $Colors.red400
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    orderView.cleanForm()
                    orderView.isEditing = false
                }
            }
        }

        ComboBoxThemed {
            id: comboBoxSupplier
            width: rectSupplier.width
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: $Models.suppliers
            textRole: 'id'
            valueRole: 'id'
            prefix: "F"
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: $Colors.white
        }

        ComboBoxThemed {
            id: comboBoxClient
            Layout.fillWidth: true
            width: rectClient.width
            Layout.fillHeight: true
            model: $Models.clients
            textRole: 'id'
            valueRole: 'id'
            prefix: "C"
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: $Colors.white
        }

        ComboBoxThemed {
            id: comboBoxArticle
            Layout.fillWidth: true
            width: rectArticle.width
            Layout.fillHeight: true
            model: $Models.articles
            textRole: 'name'
            valueRole: 'id'
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: $Colors.white
        }

        AndroidTextField {
            id: qtyOrder
            title: "Qté à commander"
            width: rectQty.width
            Layout.fillWidth: true
            Layout.fillHeight: true
            validator: IntValidator {
                bottom: 1
            }
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: $Colors.white
        }

        Item {
            Layout.preferredWidth: 30
            Layout.fillHeight: true
        }
    }


    RowLayout {
        id: tableHeader
        width: parent.width
        height: 30
        anchors.top: editArea.bottom
        anchors.topMargin: 30
        spacing: 0

        Rectangle {
            id: rectSupplier
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.colorPrimary
            Label {
                text: "Fournisseur"
                leftPadding: 5
                font {
                    weight: Font.DemiBold
                    pixelSize: 14
                }
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: $Colors.white
        }

        Rectangle {
            id: rectClient
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.colorPrimary
            Label {
                text: "Client"
                leftPadding: 5
                font {
                    weight: Font.DemiBold
                    pixelSize: 14
                }
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: $Colors.white
        }

        Rectangle {
            id: rectArticle
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.colorPrimary
            Label {
                text: "Article"
                leftPadding: 5
                font {
                    weight: Font.DemiBold
                    pixelSize: 14
                }
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: $Colors.white
        }

        Rectangle {
            id: rectQty
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.colorPrimary
            Label {
                text: "Qté"
                leftPadding: 5
                font {
                    weight: Font.DemiBold
                    pixelSize: 14
                }
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            visible: screenDeliveryView.dataset !== null
            width: 1
            Layout.fillHeight: true
            color: $Colors.white
        }

        Rectangle {
            visible: screenDeliveryView.dataset !== null
            id: rectQtyDelivered
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.colorPrimary
            Label {
                text: "Qté livrée"
                leftPadding: 5
                font {
                    weight: Font.DemiBold
                    pixelSize: 14
                }
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: $Colors.white
        }

        Rectangle {
            Layout.preferredWidth: 30
            Layout.fillHeight: true
            color: Theme.colorPrimary
        }
    }


    ListView {
        id: ordersListView
        model: $Models.orders
        anchors {
            top: tableHeader.bottom
            topMargin: 5

            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        delegate: Container {
            width: parent.width
            height: 40
            background: Rectangle {
                Rectangle {
                    anchors.bottom: parent.bottom
                    height: 1
                    color: $Colors.black
                }
            }

            contentItem: RowLayout {
                width: parent.width
                spacing: 0
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Label {
                    text: "F"+model.supplier
                    leftPadding: 5
                    font {
                        weight: Font.DemiBold
                        pixelSize: 14
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                width: 1
                Layout.fillHeight: true
                color: $Colors.white
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Label {
                    text: "C"+model.client
                    leftPadding: 5
                    font {
                        weight: Font.DemiBold
                        pixelSize: 14
                    }

                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                width: 1
                Layout.fillHeight: true
                color: $Colors.white
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Label {
                    text: $Models.articles.sqlGet(model.article)?.name
                    leftPadding: 5
                    font {
                        weight: Font.DemiBold
                        pixelSize: 14
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                width: 1
                Layout.fillHeight: true
                color: $Colors.white
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Label {
                    id: qtyText
                    visible: !qtyInput.visible
                    text: model.qty_fixed
                    leftPadding: 5
                    font {
                        weight: Font.DemiBold
                        pixelSize: 14
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        orderView.itemEditIndex = index
                        qtyInput.forceActiveFocus()
                    }
                }

                TextField {
                    id: qtyInput
                    visible: orderView.itemEditIndex === index
                    height: parent.height
                    width: parent.width / 2
                    padding: 5
                    leftPadding: 10
                    rightPadding: 10
                    text: qtyText.text
                    validator: IntValidator { bottom: 1 }
                    font {
                        weight: Font.DemiBold
                        pixelSize: 14
                    }
                    verticalAlignment: Text.AlignVCenter
                    onAccepted: {
                        if(qtyInput.text !== qtyText.text) {
                            $Models.orders.sqlUpdate(model.id, {qty_fixed: parseInt(qtyInput.text)})
                        }

                        orderView.itemEditIndex = null
                    }
                    background: Rectangle {
                        color: "transparent"
                        radius: 10
                        border {
                            width: 1
                            color: Theme.colorPrimary
                        }
                    }
                }

            }

            Rectangle {
                width: 1
                Layout.fillHeight: true
                color: $Colors.white
            }

            Rectangle {
                visible: screenDeliveryView.dataset !== null
                width: 1
                Layout.fillHeight: true
                color: $Colors.white
            }

            Rectangle {
                visible: screenDeliveryView.dataset !== null
                Layout.fillWidth: true
                Layout.fillHeight: true
                Label {
                    id: qtyRemainingText
                    text: {
                        let remaining = model.qty_fixed - screenDeliveryView.dataset?.orders[model.id].qty
                        if(remaining < model.qty_fixed) {
                            qtyRemainingText.parent.color = $Colors.red400
                            qtyRemainingText.color = $Colors.white
                        } else {
                            qtyRemainingText.parent.color = "transparent"
                            qtyRemainingText.color = $Colors.black
                        }

                        return remaining
                    }

                    leftPadding: 5
                    font {
                        weight: Font.DemiBold
                        pixelSize: 14
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ClipRect {
                Layout.preferredWidth: 30
                Layout.preferredHeight: Layout.preferredWidth
                radius: height/2
                ButtonWireframeIcon {
                    anchors.centerIn: parent
                    source: 'qrc:/assets/icons/svg/delete-forever.svg'
                    fullColor: true
                    primaryColor: $Colors.gray200
                    fulltextColor: $Colors.red400
                    MouseArea {
                        anchors.fill: parent
                        onClicked: $Models.orders.sqlRemoveFromListIndex(index)
                    }
                }
            }
        }

    }

    Label {
        text: "Aucune commande"
        font.pixelSize: 24
        font.weight: Font.Light
        visible: ordersListView.model.count === 0
        color: Theme.colorPrimary
        anchors.centerIn: parent
    }
}
