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
    id: root
    background: Rectangle {
        color: Theme.colorBackground //$Colors.gray100
    }

    QtObject {
        id: nodeClient
        property color color: 'red'
        property int size: 20
    }
    QtObject {
        id: nodeSupplier
        property color color: 'green'
        property int size: 20
    }
    QtObject {
        id: nodeWarehouse
        property color color: 'yellow'
        property int size: 20
    }

    property int currentPage: 0
    property int totalCount: 0

    property string paintingNodeType: ""

    AddOrder {
        id: addOrderDrawer

        width: parent.width / 1.5
        height: parent.height
        edge: Qt.LeftEdge
        dim: true
        modal: true
        interactive: true
    }
    Row {
        id: head
        width: parent.width
        spacing: 20
        leftPadding: 20
        Label {
            text: $Models.clients.count + " clients"
        }
        Label {
            text: $Models.suppliers.count + " fournisseurs"
        }
        Label {
            text: $Models.warehouses.count + " dépots"
        }
    }

    Canvas {
        anchors {
            top: head.bottom
            bottom: parent.bottom
            bottomMargin: 20
            left: parent.left
            right: areaSelector.left
            rightMargin: 10
        }
        MouseArea {
            anchors.fill: parent
            onClicked: function (event) {
                if (root.paintingNodeType === "C") {
                    $Models.clients.sqlCreate({
                                                  "x": event.x,
                                                  "y": event.y
                                              })
                }
                if (root.paintingNodeType === "S") {
                    $Models.suppliers.sqlCreate({
                                                    "x": event.x,
                                                    "y": event.y
                                                })
                }
                if (root.paintingNodeType === "W") {
                    $Models.warehouses.sqlCreate({
                                                     "x": event.x,
                                                     "y": event.y
                                                 })
                } else {
                    console.log("NOne")
                }
                console.log("selected ", root.paintingNodeType,
                            paintingNodeType === "")
            }
        }

        Repeater {
            model: $Models.clients
            delegate: Rectangle {
                required property var model
                required property int index
                x: model.x - width / 2
                y: model.y - height / 2
                width: 30
                height: width
                color: nodeClient.color
                radius: height / 2
                DragHandler {
                    onGrabChanged: function() {
                        $Models.clients.sqlUpdate(model.id, {
                                                  x: parent.x + parent.width / 2,
                                                  y: parent.y + parent.height / 2
                                              })
                    }

                }
                Label {
                    text: "C" + model.id
                    font.weight: Font.DemiBold
                    color: $Colors.white
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: addOrderDrawer.show(model, "client", index)
                }
                //                Text {
                //                       color: handler.active ? "darkgreen" : "black"
                //                       text: handler.centroid.position.x.toFixed(1) + "," + handler.centroid.position.y.toFixed(1)
                //                       x: handler.centroid.position.x - width / 2
                //                       y: handler.centroid.position.y - height
                //                   }
            }
        }

        Repeater {
            model: $Models.suppliers
            delegate: Rectangle {
                required property var model
                required property int index
                x: model.x - width / 2
                y: model.y - height / 2
                width: 30
                height: width
                color: nodeSupplier.color
                radius: height / 2
                DragHandler {
                    onGrabChanged: function() {
                        $Models.suppliers.sqlUpdate(model.id, {
                                                        x: parent.x + parent.width / 2,
                                                        y: parent.y + parent.height / 2
                                              })
                    }
                }
                Label {
                    text: "F" + model.id
                    font.weight: Font.DemiBold
                    color: $Colors.white
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: addOrderDrawer.show(model, "supplier", index)
                }
            }
        }

        Repeater {
            model: $Models.warehouses
            delegate: Rectangle {
                required property var model
                x: model.x - width / 2
                y: model.y - height / 2
                width: 30
                height: width
                color: nodeWarehouse.color
                DragHandler {
                    onGrabChanged: function() {
                        $Models.warehouses.sqlUpdate(model.id, {
                                                         x: parent.x + parent.width / 2,
                                                         y: parent.y + parent.height / 2
                                              })
                    }
                }
                Label {
                    text: "D" + model.id
                    font.weight: Font.DemiBold
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: confirmDelete.show({
                                                      "subtitle": "Voulez-vous vraiment supprimer le dépot D" + model.id + " ?",
                                                      "callback": function (closeFunc) {
                                                          if ($Models.warehouses.sqlRemove(
                                                                      model.id)) {
                                                              closeFunc()
                                                          }
                                                      }
                                                  })
                }
            }
        }
    }

    ColumnLayout {
        id: areaSelector
        anchors {
//            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 10
        }
        x: 10
        y: (parent.height / 2) - height/2
        DragHandler {}

        Container {
            id: _col
            Layout.minimumHeight: 300
            background: Rectangle {
                radius: 30
                color: $Colors.gray300
            }
            contentItem: ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 30
            }
            Timer {
                id: selectorClientTimer
                interval: 500
                repeat: true
                onTriggered: {
                    root.paintingNodeType = "C"
                    selectorClient.opacity = selectorClient.opacity === 1 ? 0 : 1
                }
                onRunningChanged: {
                    if (!running)
                        selectorClient.opacity = 1
                }
            }

            Timer {
                id: selectorSupplierTimer
                interval: 500
                repeat: true
                onTriggered: {
                    root.paintingNodeType = "S"
                    selectorSupplier.opacity = selectorSupplier.opacity === 1 ? 0 : 1
                }
                onRunningChanged: {
                    if (!running)
                        selectorSupplier.opacity = 1
                }
            }

            Timer {
                id: selectorWarehouseTimer
                interval: 500
                repeat: true
                onTriggered: {
                    root.paintingNodeType = "W"
                    selectorWarehouse.opacity = selectorWarehouse.opacity === 1 ? 0 : 1
                }
                onRunningChanged: {
                    if (!running)
                        selectorWarehouse.opacity = 1
                }
            }

            Item {
                Layout.preferredHeight: 50
            }

            Column {
                Layout.fillWidth: true

                Rectangle {
                    id: selectorWarehouse
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 30
                    height: width
                    radius: height / 2
                    color: nodeWarehouse.color
                    Behavior on opacity {
                        OpacityAnimator {
                            duration: 333
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (selectorWarehouseTimer.running) {
                                root.paintingNodeType = ""
                                selectorWarehouseTimer.stop()
                            } else {
                                selectorClientTimer.stop()
                                selectorSupplierTimer.stop()

                                selectorWarehouseTimer.start()
                            }
                        }
                    }
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Dépot"
                }
            }

            Column {
                Layout.fillWidth: true

                Rectangle {
                    id: selectorClient
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 30
                    height: width
                    radius: height / 2
                    color: nodeClient.color
                    Behavior on opacity {
                        OpacityAnimator {
                            duration: 333
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (selectorClientTimer.running) {
                                root.paintingNodeType = ""
                                selectorClientTimer.stop()
                            } else {
                                selectorSupplierTimer.stop()
                                selectorWarehouseTimer.stop()

                                selectorClientTimer.start()
                            }
                        }
                    }
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Client"
                }
            }

            Column {
                Rectangle {
                    id: selectorSupplier
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 30
                    height: width
                    radius: height / 2
                    color: nodeSupplier.color
                    Behavior on opacity {
                        OpacityAnimator {
                            duration: 333
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (selectorSupplierTimer.running) {
                                root.paintingNodeType = ""
                                selectorSupplierTimer.stop()
                            } else {
                                // Shutdown others
                                selectorClientTimer.stop()
                                selectorWarehouseTimer.stop()

                                selectorSupplierTimer.start()
                            }
                        }
                    }
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Fournisseur"
                }
            }

            Item {
                Layout.preferredHeight: 50
            }
        }
    }
}
