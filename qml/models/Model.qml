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
    signal deletedAll()

    function define() {
        throw "This function must be overriden"
    }

    function init() {
        return new Promise(function(resolve, reject) {
            try {
                control.model = control.define()
                console.log(control.model)
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
    function sqlFilter(closes) {
        return control.model.filter(closes).all()
    }
    function sqlGet(pk) {
        return control.model.filter({id: pk}).all()[0]
    }
    function sqlRemove(pk) {
        let res = control.model.filter({id: pk})
        if(res.all().length === 0) {
            control.model.filter({id: pk}).remove()
            deleted(pk)
            return true
        }
        return false
    }
    function sqlRemoveAll(pk) {
        control.model.remove()
        deletedAll()
    }

    onReady: fetchAll()
    onCreated: function (data) {
        append(data)
    }
    onDeletedAll: {
        control.clear()
        control.fetchAll()
    }
    onDeleted: function (id){
        for(let i=0; i<control.count; i++) {
            if(control.get(i).id === id) {
                control.remove(i)
                break
            }
        }
    }
}
