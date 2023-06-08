import QtQuick

Model {
    debug: true
    tableName: "ModelClient"
    column: [{
            "name": "id",
            "type": "INTEGER",
            "key": "PRIMARY KEY"
        }, {
            "name": "x",
            "type": "REAL"
        }, {
            "name": "y",
            "type": "REAL"
        }, {
            "name": "displayName",
            "type": "TEXT"
        },{
            "name": "created_at",
            "type": "REAL"
        }, {
            "name": "updated_at",
            "type": "REAL"
        }]
}
