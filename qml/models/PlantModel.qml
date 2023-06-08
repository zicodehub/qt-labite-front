import QtQuick

import "../services/"

Model {
    debug: true
    tableName: "Plant"
    column: [{
            "name": "id",
            "type": "INTEGER",
            "key": "PRIMARY KEY"
        }, {
            "name": "remote_id",
            "type": "INTEGER"
        }, {
            "name": "status",
            "type": "INTEGER",
            "def": 0
        }, {
            "name": "created_at",
            "type": "REAL"
        }, {
            "name": "updated_at",
            "type": "REAL"
        }]
}
