import QtQuick

import "../services"

Model {
    id: control
    debug: true
    tableName: "Vehicule"

    function define() {
        return control.db.define(control.tableName, {
            warehouse: control.db.FK( "Warehouse", {'references': "Warehouse"}),
             nb_compartments: control.db.Integer('Compartments ', {accept_null:false}),
             size_compartment: control.db.Integer('Taille des compartiments ', {accept_null:false}),
             cost: control.db.Integer('Cout du véhicule ', {accept_null:false}),
        });
    }
}
