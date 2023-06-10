import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Drawer {
    id: control

    property string title: "Confirmer la suppression"
    property string subtitle: ""
    property string textCancel: "Supprimer"
    property string textDelete: "Annuler"

    property bool isOpen: false
    property var callback: function (closeFunction) {
        closeFunction()
    }

    property var show: function (config) {
        if(config.title) title = config.title
        if(config.subtitle) subtitle = config.subtitle
        if(config.textCancel) textCancel = config.textCancel
        if(config.textDelete) textDelete = config.textDelete
        if(config.callback) callback = config.callback
        open()
    }

    onClosed: {
        subtitle = ""
        title = "Confirmer la suppression"
        textCancel = "Supprimer"
        textDelete = "Annuler"
        isOpen = false
    }

    onOpened: {
        isOpen = true
    }

    function handleClose() {
        callback(function () {
            control.close()
        })()
    }

    edge: Qt.LeftEdge
    dim: true
    modal: true
    interactive: true
    padding: 20

    Loader {
        id: contentLoader
        active: isOpen
        anchors.fill: parent
        anchors.margins: 20
        sourceComponent: Item {
            anchors.fill: contentLoader
            ColumnLayout {
                width: parent.width - 2*parent.padding
                height: parent.height
                Item {
                    Layout.fillHeight: true
                }
                Label {
                    text: title
                    font {
                        pixelSize: 16
                        weight: Font.Bold
                    }
                }
                Label {
                    text: subtitle
                }
                Item {
                    Layout.fillHeight: true
                }
                RowLayout {
                    width: parent.width
                    AndroidButtonIcon {
                        text: textCancel
                        source: 'qrc:/assets/icons/svg/delete-forever-outline.svg'
                        primaryColor: $Colors.white
                        backgroundItem.color: $Colors.red400
                        onClicked: handleClose()
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    AndroidButtonIcon {
                        text: textDelete
                        onClicked: control.close()
                    }
                }
            }
        }
    }



}
