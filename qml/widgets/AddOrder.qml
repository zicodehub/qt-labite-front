import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import ThemeEngine
import "qrc:/qml"
import "../components_generic"

Drawer {
    id: control

    property var customModel: null
    property bool isEditing: false
    property var currentNode: null
    property bool isFormValid: comboBoxSupplier.currentIndex > -1 && comboBoxClient.currentIndex > -1 && comboBoxArticle.currentIndex > -1 && qtyOrder.text != ""

    property var show: function(node, nodeType, nodeIndex) {
        console.log(" Likc show", )
        var results
        if(nodeType === 'client') {
            results = $Models.orders.sqlFilter({client: node.id})
            comboBoxClient.currentIndex = nodeIndex
            comboBoxClient.enabled = false
        } else if(nodeType === 'supplier') {
            results = $Models.orders.sqlFilter({supplier: node.id})
            comboBoxSupplier.currentIndex = nodeIndex
            comboBoxSupplier.enabled = false
        } else return
        for (let i=0; i< results.length; i++) {
            proxyModel.insert(0, results[i])
        }
        node.nodeType = nodeType
        control.currentNode = node
        open()
    }

    leftPadding: 10
    rightPadding: 10

    onClosed: {
        currentNode = null
        isEditing = true
        comboBoxSupplier.currentIndex = -1
        comboBoxSupplier.enabled = true

        comboBoxClient.currentIndex = -1
        comboBoxClient.enabled = true

        comboBoxArticle.currentIndex = -1
        comboBoxArticle.enabled = true

        qtyOrder.text = ""
        isEditing = false
        proxyModel.clear()
    }

    ListModel {
        id: proxyModel
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

            AndroidButtonIcon {
                text: "Supprimer le noeud "+(currentNode?.nodeType === 'client' ? 'C' : currentNode?.nodeType === 'supplier' ? 'F' : '' ) + currentNode?.id
                source: 'qrc:/assets/icons/svg/delete-forever-outline.svg'
                primaryColor: $Colors.white
                backgroundItem.color: $Colors.red400
                onClicked: {
                    if(currentNode.nodeType === "client") {
                        const relatedOrders = $Models.orders.sqlFilter({client: currentNode.id})
                        confirmDelete.show({
                          "subtitle": relatedOrders.length > 0 ? `Toutes les (${relatedOrders.length}) commandes effectuée seront aussi supprimées ` : '',
                          "callback": function (closeFunc) {
                              if(relatedOrders.length > 0 ) {
                                  $Models.orders.sqlRemoveMany({client: currentNode.id})
                              }

                              if ($Models.clients.sqlRemove(currentNode.id)) {
                                  closeFunc()
                                  control.close()
                              }
                          }

                        })

                    }

                    if(currentNode.nodeType === "supplier") {
                        const relatedOrders = $Models.orders.sqlFilter({supplier: currentNode.id})
                        confirmDelete.show({
                          "subtitle": relatedOrders.length > 0 ? `Toutes les (${relatedOrders.length}) commandes effectuée seront aussi supprimées ` : '',
                          "callback": function (closeFunc) {
                              if(relatedOrders.length > 0 ) {
                                  $Models.orders.sqlRemoveMany({supplier: currentNode.id})
                              }

                              if ($Models.suppliers.sqlRemove(currentNode.id)) {
                                  closeFunc()
                                  control.close()
                              }
                          }

                        })
                    }

                }
            }

        }

        RowLayout {
            width: parent.width
            spacing: 10
            Label {
                text: proxyModel.count + " commandes"
                font.pixelSize: 24
                font.weight: Font.Light
            }

            Item {
                Layout.fillWidth: true
            }
            AndroidButtonIcon {
                text: "Créer une commande"
                source: "qrc:/assets/icons/svg/content-save-plus.svg"
                visible: !control.isEditing
                onClicked: {
                    control.isEditing = !control.isEditing
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
                    proxyModel.insert(0, order)
                    qtyOrder.text = ""
    //                control.close()
                }
            }
        }
    }

    RowLayout {
        id: editArea
        visible: control.isEditing
        width: parent.width
        height: 50
        anchors.top: header.bottom
        anchors.topMargin: 30
        spacing: 0

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
        model: customModel || proxyModel
        anchors {
            top: tableHeader.bottom
            topMargin: 5

            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        delegate: Container {
            width: ordersListView.width
            height: 30
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
                    text: model.qty_fixed
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

            IconSvg {
                Layout.preferredWidth: 30
                Layout.preferredHeight: Layout.preferredWidth
                source: 'qrc:/assets/icons/svg/delete-forever.svg'
                color: $Colors.red400
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if($Models.orders.sqlRemove(model.id)) {
                            proxyModel.remove(index)
                        }

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
