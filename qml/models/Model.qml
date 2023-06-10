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
        return control.model.update(data)
    }
    function makeObject() {
        return control.model.makeObject()
    }
    function fetchAll() {
        var data = control.model.all()
        for(let i=0; i< data.length; i++) {
            insert(0, data[i])
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
        let found = res.all().length
        console.log("Found ", found)
        if(found === 1) {
            control.model.filter({id: pk}).remove()
            deleted(pk)
            return true
        }
        return false
    }

    function sqlRemoveFromListIndex(index) {
        let pk = control.get(index)?.id
        if(pk) {
            control.model.filter({id: pk}).remove()
            deleted(pk)
            return true
        }
        return false

    }

    function sqlRemoveMany(filters) {
        const items = control.model.filter(filters).all()
        control.model.filter(filters).remove()
        console.log("\n Gonna remove many ", items, items.map(i => i.id))
        for(let idx in items) {
            deleted(items[idx].id)
        }

        return true
    }

    function sqlRemoveAll(pk) {
        control.model.remove()
        deletedAll()
        return true
    }

    onReady: fetchAll()
    onCreated: function (data) {
        insert(0, data)
    }
    onDeletedAll: {
        control.clear()
        control.fetchAll()
    }
    onDeleted: function (id){
        console.log("Deleting id=", id, " for count = ", control.count)
        for(let i=0; i<control.count; i++) {
            if(control.get(i).id === id) {
                control.remove(i)
                console.log("Found at index = ", i)
                break
            }
        }
    }
}
