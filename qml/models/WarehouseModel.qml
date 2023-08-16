import QtQuick

import "../services"

Model {
    id: control
    debug: true
    tableName: "Warehouse"

    function define() {
        return control.db.define(control.tableName, {
            x: control.db.Float('X coord', {accept_null:false}),
            y: control.db.Float('Y coord', {accept_null:false}),
            area_id: control.db.Integer('Area ID', {accept_null: true})
        });
    }
}
