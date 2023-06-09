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
    background: Rectangle {
        color: $Colors.gray100
    }

    RowLayout {
        id: tableHeader
        width: parent.width
        height: 30
        anchors.top: parent.top
        anchors.topMargin: 30
        spacing: 0

        Rectangle {
            id: rectSupplier
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.colorPrimary
            Label {
                text: "Fournisseur"
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
                anchors.verticalCenter: parent.verticalCenter
            }
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
            height: 30
            background: Rectangle {
                color: index % 2 == 0 ? 'red' : 'green'

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
                    anchors.verticalCenter: parent.verticalCenter
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
