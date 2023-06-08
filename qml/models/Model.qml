import QtQuick

import "qrc:/js/ORM.js" as ORM

ListModel {
    id: control
    required  property string tableName
    required property var db

    property bool debug: false
    property var model

    signal fetched
    signal ready
    signal removed(var id)
    signal removeds(var ids)
    signal created(var id)
    signal createds(var id)
    signal updated(var id)
    signal deleted(var id)

    function define() {
        throw "This function must be overriden"
    }

    function init() {
        return new Promise(function(resolve, reject) {
            try {
                control.model = control.define()
                resolve()
                ready()
            } catch(e) {
                reject(e)
            }

        })
    }

    function sqlCreate(data) {
        var res = control.model.create(data)
        if(res) {
            console.log(JSON.stringify(res), " --- ID:: ", res.id)
            created(res)
        }
        return res
    }
    function sqlUpdate(data) {
        return control.model.create(data)
    }
    function makeObject() {
        return control.model.makeObject()
    }
    function update(id, data) {
        return control.model.filter({id: pk}).update(data)
    }
    function remove(pk) {
        return control.model.filter({id: pk}).remove()
    }
    function fetchAll() {
        var data = control.model.all()
        for(let i=0; i< data.length; i++) {
            append(data[i])
        }
    }

    onReady: fetchAll()
    onCreated: function (data) {
        append(data)
    }
}
