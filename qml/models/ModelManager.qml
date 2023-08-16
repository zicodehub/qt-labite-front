import QtQuick
import QtQuick.Controls
import QtQuick.Window

import QtCore
import Qt.labs.settings
import ThemeEngine 1.0

import "../services"
import "qrc:/js/ORM.js" as QuickModel

Item {
    id: _relay

    property string dbName: dbSettings.value("db/name") ?? (new Date()).toString()
    property var quickModelDB: new QuickModel.QMDatabase(dbName, '1.0')

    property var clients: _clientModel
    property var suppliers: _supplierModel
    property var warehouses: _warehouseModel
    property var typeArticles: _typeArticleModel
    property var articles: _articleModel
    property var vehicules: _vehiculeModel
    property var orders: _orderModel

    Settings {
        id: dbSettings
    }

    ////// MODEL BEGIN ->
    ClientModel {
        id: _clientModel
        db: quickModelDB
    }

    SupplierModel {
        id: _supplierModel
        db: quickModelDB
    }

    WarehouseModel {
        id: _warehouseModel
        db: quickModelDB
    }

    VehiculeModel {
        id: _vehiculeModel
        db: quickModelDB
    }

    TypeArticleModel {
        id: _typeArticleModel
        db: quickModelDB
    }

    ArticleModel {
        id: _articleModel
        db: quickModelDB
    }

    OrderModel {
        id: _orderModel
        db: quickModelDB
    }

    function init() {

        Promise.all([clients.init(), suppliers.init(), warehouses.init(), typeArticles.init(), articles.init(), vehicules.init(), orders.init()]).then(function (rs) {
            console.info("[+] All table ready")
        }).catch(function (rs) {
            console.error("Something happen when loading DB tables => ", rs)
        })
    }

    function loseAndChangeDB() {
        const newDBName = (new Date()).toString()
        dbName = newDBName
//        _relay.quickModelDB = new QuickModel.QMDatabase(newDBName, '1.0')
        dbSettings.setValue("db/name", newDBName)
        init()
    }

    Component.onCompleted: init()
    Component.onDestruction: {
        dbSettings.setValue("db/name", newDBName)
    }

}
