import QtQuick 2.5
import QtQuick.Controls 2.5
import Qt.labs.settings 1.0
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    color:'black'

    SQL{
        id:test_sql

        width:80
        height:80
    }
}
