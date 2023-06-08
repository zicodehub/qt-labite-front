import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/qml"

Drawer {
    id: control


    Item {
        anchors.fill: parent
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            AndroidTextField {
                id: nameArticle
                title: "Nom de l'article"
                Layout.fillWidth: true
            }

            ComboBoxThemed {
                id: comboBoxAppTheme
                Layout.fillWidth: true
//                currentIndex: 0
                model: $Models.typeArticle
                textRole: 'name'
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
                    source: "qrc:/assets/icons_material/baseline-accessibility-24px.svg"
                    onClicked: {
                        if(nameArticle.text !== "" && comboBoxAppTheme.currentIndex > -1) {
                            console.log()
                            let res = $Models.article.sqlCreate({name: nameArticle.text, type_article: $Models.typeArticle.get(comboBoxAppTheme.currentIndex).id})
                            if(res) control.close()
                        }
                    }
                }
            }

        }
    }
}
