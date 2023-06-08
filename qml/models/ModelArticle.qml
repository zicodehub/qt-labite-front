import QtQuick

import "../services/"

Model {
    debug: true
    tableName: "Article"
    column: [{
            "name": "id",
            "type": "INTEGER",
            "key": "PRIMARY KEY"
        }, {
            "name": "type_article_id",
            "type": "INTEGER"
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
