import QtQuick 2.5
import QtQuick.Controls 2.5
import Qt.labs.settings 1.0

Rectangle {
    id: root

    width: 320
    height: 240
    color: settings.color // default color

    Settings {

        id: settings
        category: 'window'
        property color color : "black"
        property alias x:  window.x
    }

    Component.onCompleted: {
        console.log("x :::",x)

    }
}
