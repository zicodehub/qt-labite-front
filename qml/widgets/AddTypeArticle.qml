import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml"

Drawer {
    id: control

    onClosed: {
        nameTypeArticle.text = ""
    }

    Item {
        anchors.fill: parent
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            AndroidTextField {
                id: nameTypeArticle
                title: "Nom du type d'article"
                Layout.fillWidth: true
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
                        if(nameTypeArticle.text !== "") {
                            let res = $Models.typeArticles.sqlCreate({name: nameTypeArticle.text})
                            if(res) control.close()
                        }
                    }
                }
            }

        }
    }
}
