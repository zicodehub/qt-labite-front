import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt.labs.settings

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
    property bool shouldDisplayArea: false
    property bool isMultiWarehouses: false

    Settings {
        id: areasSettings
    }

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


        Item {
            width: 100
            height: 1
        }
        Row {
            Label {
                text: "Activer le multi dépots"
            }
            Switch {
                id: switchIsMultiWarehouses
                onPositionChanged: root.isMultiWarehouses = !root.isMultiWarehouses
            }
        }


        Item {
            width: 100
            height: 1
        }
        Row {
            visible: root.isMultiWarehouses
            Label {
                text: "Vérifier les zones ?"
            }
            Switch {
                id: switchShouldDisplayArea
                onPositionChanged: root.shouldDisplayArea = !root.shouldDisplayArea
            }
        }

    }

    Item {
        anchors {
            top: head.bottom
            bottom: parent.bottom
            bottomMargin: 20
            left: parent.left
            right: areaSelector.left
            rightMargin: 10
        }

        Component.onCompleted: {
            splitView.restoreState(areasSettings.value("ui/splitview"))
            nodesArea.updateNodesArea()
        }

        Component.onDestruction: areasSettings.setValue("ui/splitview", splitView.saveState())

        Canvas {
            id: nodesArea
            anchors.fill: parent

            function updateNodesArea() {
                nodesArea.updateWarehousesArea()
                nodesArea.updateClientsArea()
                nodesArea.updateSuppliersArea()
            }

            function updateClientsArea() {
                const total = $Models.clients.count;
                for(let i = 0; i<total; i++) {
                    const client = $Models.clients.get(i)
                    const area_id = nodesArea.getDispatchArea(client.x, client.y)
                    $Models.clients.sqlUpdate(client.id, {
                        "area_id": area_id
                    })
                }
            }
            function updateSuppliersArea() {
                const total = $Models.suppliers.count;
                for(let i = 0; i<total; i++) {
                    const client = $Models.suppliers.get(i)
                    const area_id = nodesArea.getDispatchArea(client.x, client.y)
                    $Models.suppliers.sqlUpdate(client.id, {
                        "area_id": area_id
                    })
                }
            }
            function updateWarehousesArea() {
                const total = $Models.warehouses.count;
                for(let i = 0; i<total; i++) {
                    const client = $Models.warehouses.get(i)
                    const area_id = nodesArea.getDispatchArea(client.x, client.y)
                    $Models.warehouses.sqlUpdate(client.id, {
                        "area_id": area_id
                    })
                }
            }

            function getDispatchArea(x, y) {
                if(x >= area3.x) return 3
                if(x >= area2.x) return 2
//                if(x >= area1.x) return 1
                console.log(x, '  --> ', area3.x, '  --> ', area2.x, '  --> ', area1.x)
                return 1
//                return "NO AREA FOUND"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: function (event) {
                    if (root.paintingNodeType === "C") {
                        $Models.clients.sqlCreate({
                                                      "x": event.x,
                                                      "y": event.y,
                                                      "area_id": nodesArea.getDispatchArea(event.x, event.y)
                                                  })
                    }
                    if (root.paintingNodeType === "S") {
                        $Models.suppliers.sqlCreate({
                                                        "x": event.x,
                                                        "y": event.y,
                                                        "area_id": nodesArea.getDispatchArea(event.x, event.y)
                                                    })
                    }
                    if (root.paintingNodeType === "W") {
                        $Models.warehouses.sqlCreate({
                                                         "x": event.x,
                                                         "y": event.y,
                                                         "area_id": nodesArea.getDispatchArea(event.x, event.y)
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
                    width: screenSettings.nodeSize
                    height: width
                    color: nodeClient.color
                    radius: height / 2
                    DragHandler {
                        onGrabChanged: function() {
                            $Models.clients.sqlUpdate(model.id, {
                                                      x: parent.x + parent.width / 2,
                                                      y: parent.y + parent.height / 2,
                                                      area_id: nodesArea.getDispatchArea(parent.x + parent.width / 2, parent.y + parent.height / 2)
                                                  })
                        }

                    }
                    Label {
                        text: root.shouldDisplayArea ? model.area_id : "C" + model.id
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
                    Component.onCompleted: {
                        console.log("--- C", model.id, nodesArea.getDispatchArea(model.x, model.y))
                    }
                }
            }

            Repeater {
                model: $Models.suppliers
                delegate: Rectangle {
                    required property var model
                    required property int index
                    x: model.x - width / 2
                    y: model.y - height / 2
                    width: screenSettings.nodeSize
                    height: width
                    color: nodeSupplier.color
                    radius: height / 2
                    DragHandler {
                        onGrabChanged: function() {
                            $Models.suppliers.sqlUpdate(model.id, {
                                                            x: parent.x + parent.width / 2,
                                                            y: parent.y + parent.height / 2,
                                                            area_id: nodesArea.getDispatchArea(parent.x + parent.width / 2, parent.y + parent.height / 2)
                                                  })
                        }
                    }
                    Label {
                        text: root.shouldDisplayArea ? model.area_id : "F" + model.id
                        font.weight: Font.DemiBold
                        color: $Colors.white
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: addOrderDrawer.show(model, "supplier", index)
                    }
                    Component.onCompleted: console.log("--- S", model.id)
                }
            }

            Repeater {
                model: $Models.warehouses
                delegate: Rectangle {
                    required property var model
                    x: model.x - width / 2
                    y: model.y - height / 2
                    width: screenSettings.nodeSize
                    height: width
                    color: nodeWarehouse.color
                    DragHandler {
                        onGrabChanged: function() {
                            $Models.warehouses.sqlUpdate(model.id, {
                                                             x: parent.x + parent.width / 2,
                                                             y: parent.y + parent.height / 2,
                                                             area_id: nodesArea.getDispatchArea(parent.x + parent.width / 2, parent.y + parent.height / 2)
                                                  })
                        }
                    }
                    Label {
                        text: root.shouldDisplayArea ? model.area_id : "D" + model.id
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
                    Component.onCompleted: console.log("--- W", model.id)}
            }
        }

        SplitView {
            id: splitView
            anchors.fill: parent
            orientation: Qt.Horizontal
            visible: root.isMultiWarehouses

            handle: Rectangle {
                id: handleDelegate
                implicitWidth: 4
                implicitHeight: 4
                color: SplitHandle.pressed ? "#81e889"
                    : (SplitHandle.hovered ? Qt.lighter("#c2f4c6", 1.1) : "#c2f4c6")

                containmentMask: Item {
                    x: (handleDelegate.width - width) / 2
                    width: 10
                    height: splitView.height
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }
            }

            property bool isDragFinished: true
            onResizingChanged: {
                isDragFinished = !isDragFinished
                if(isDragFinished) {
                    console.log("DRAG FINISHED")
                    nodesArea.updateNodesArea()
                }

            }

            Rectangle {
                id: area1
                SplitView.preferredWidth: 240
                color: 'orange'
                opacity: 0.2
            }


            Rectangle {
                id: area2
                SplitView.preferredWidth: 60
                color: 'green'
                opacity: 0.2
            }

            Rectangle {
                id: area3
                SplitView.preferredWidth: 60
                color: 'blue'
                opacity: 0.2
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
