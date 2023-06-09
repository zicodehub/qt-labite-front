import QtQuick

import "../services"

Model {
    id: control
    debug: true
    tableName: "MyOrder"

    function define() {
        return control.db.define(control.tableName, {
                                     client: control.db.FK("Client", {
                                                                 "references": "Client"
                                                             }),
                                     supplier: control.db.FK("Supplier", {
                                                                   "references": "Supplier"
                                                               }),
                                     article: control.db.FK("Article", {
                                                                  "references": "Article"
                                                              }),
                                     qty_fixed: control.db.Integer(
                                                      'Qty fixed ', {
                                                          "accept_null": false
                                                      })
                                 })
    }
}
