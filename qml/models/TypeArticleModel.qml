import QtQuick

import "../services"

Model {
    id: control
    debug: true
    tableName: "TypeArticle"

    function define() {
        return control.db.define(control.tableName, {
            name: control.db.String('Type name', {accept_null: true})
        });
    }
}
