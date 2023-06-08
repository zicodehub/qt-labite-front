import QtQuick

import "../services/"

Model {
    debug: true
    tableName: "TypeArticle"
    column: [{
            "name": "id",
            "type": "INTEGER",
            "key": "PRIMARY KEY"
        }, {
            "name": "name",
            "type": "TEXT"
        },{
            "name": "created_at",
            "type": "REAL"
        }, {
            "name": "updated_at",
            "type": "REAL"
        }]
}
