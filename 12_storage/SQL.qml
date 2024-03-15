import QtQuick 2.5
import QtQuick.LocalStorage 2.15


Item {
    property var db;

    Rectangle{
        id:crazy
        objectName:'crazy'
        width:100
        height:100
        x:50
        y:50
        color:'light green'
        border.color:'blue'
        Text{
            anchors.centerIn: parent
            text:Math.round(parent.x) + '/' + Math.round(parent.y)

        }

        MouseArea{
            anchors.fill:parent
            drag.target:parent
        }
    }

    function initDatabase(){
        print('initDatabase()');
        db = LocalStorage.openDatabaseSync("crazyBox","1.0","Box DB",100000);

        db.transaction(function(tx){
            print("...created new table");
            tx.executeSql('CREATE TABLE IF NOT EXISTS data(name TEXT, value TEXT)');
            });
    }

    function readData() {
           print('readData()')
           if(!db) { return; }
           db.transaction( function(tx) {
               print('... read crazy object')
               var result = tx.executeSql('select * from data where name="crazy"');
               if(result.rows.length === 1) {
                   print('... update crazy geometry')
                   // get the value column
                   var value = result.rows[0].value;
                   // convert to JS object
                   var obj = JSON.parse(value)
                   // apply to object
                   crazy.x = obj.x;
                   crazy.y = obj.y;
               }
           });
    }

    function storeData(){
        print('storeData()');
        if(!db){return;}

        db.transaction( function(tx) {
            print('... check if a crazy object exists');
            var result = tx.executeSql('select * from data where name="crazy"');
            var obj = { x:crazy.x, y:crazy.y }
            if(result.rows.length === 1) {
                print('... crazy exist, update it');
                result = tx.executeSql('UPDATE data set value=? where name="crazy"',[JSON.stringify(obj)]);
            }else{
                print('... crazy does not exist, create it')
                result= tx.executeSql('INSERT INTO data VALUES(?,?)',['crazy',JSON.stringify(obj)]);
            }
        });
    }

    Component.onCompleted: {
        initDatabase();
        readData();
    }

    Component.onDestruction: {
        storeData();
    }
}
