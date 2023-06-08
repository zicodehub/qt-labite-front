import QtQuick

import "../services"

Model {
    id: control
    debug: true
    tableName: "Client"

    function define() {
        return control.db.define(control.tableName, {
            x: control.db.Float('X coord', {accept_null:false}),
            y: control.db.Float('Y coord', {accept_null:false})
        });
    }
}
