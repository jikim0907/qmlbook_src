import QtQuick 2.5
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "colorservice.js" as Service

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    property var gridModel : view.model
    Rectangle{
            id:box
            width: 360
            height: 360
            color:"#000"

            GridView{
                id: view
                anchors.fill:parent
                cellWidth:width/4
                cellHeight:cellWidth

                delegate:Rectangle{
                    width: view.cellWidth
                    height: view.cellHeight
                    color: modelData.value //등록된 배열의 value키 값을 color로 쓸 수 있음
                }
            }
        }

    Item{
        id:root
        width: 300;height:300;
        Column{
            spacing:2

            Button {
                text: 'Read Colors';
                // anchors.fill : parent
                onClicked: {
                    Service.get_colors( function(resp) {
                        print('handle get colors resp: ' + JSON.stringify(resp));
                        gridModel.clear();
                        var entries = resp.data;
                        for(var i=0; i<entries.length; i++) {
                            gridModel.append(entries[i]);
                        }
                    });
                }
            }

            Button {
                text: 'Create New';
                onClicked: {
                    var index = gridModel.count-1
                    var entry = {
                        name: 'color-' + index,
                        value: Qt.hsla(Math.random(), 0.5, 0.5, 1.0).toString()
                    }
                    Service.create_color(entry, function(resp) {
                        print('handle create color resp: ' + JSON.stringify(resp))
                        gridModel.append(resp)
                    });
                }
            }

            Button {
                text: 'Read Last Color';
                onClicked: {
                    var index = gridModel.count-1
                    var name = gridModel.get(index).name
                    Service.get_color(name, function(resp) {
                        print('handle get color resp:' + JSON.stringify(resp))
                        message.text = resp.value
                    });
                }
            }

            Button {
                text: 'Update Last Color'
                onClicked: {
                    var index = gridModel.count-1
                    var name = gridModel.get(index).name
                    var entry = {
                        value: Qt.hsla(Math.random(), 0.5, 0.5, 1.0).toString()
                    }
                    Service.update_color(name, entry, function(resp) {
                        print('handle update color resp: ' + JSON.stringify(resp))
                        var index = gridModel.count-1
                        gridModel.setProperty(index, 'value', resp.value)
                    });
                }
            }

            Button {
                text: 'Delete Last Color'
                onClicked: {
                    var index = gridModel.count-1
                    var name = gridModel.get(index).name
                    Service.delete_color(name)
                    gridModel.remove(index, 1)
                }
            }
        }
    }

}
