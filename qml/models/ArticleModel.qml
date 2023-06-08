import QtQuick

import "../services"

Model {
    id: control
    debug: true
    tableName: "Article"

    function define() {
        return control.db.define(control.tableName, {
            name: control.db.String('X coord', {accept_null: true}),
            type_article: control.db.FK( "TypeArticle", {'references': "TypeArticle"}),
        });
    }
}
