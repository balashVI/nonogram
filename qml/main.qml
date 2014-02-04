import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

import "../qml"

Window {
    id: main
    width: 800
    height: 500

    Flipable{
        anchors.fill: parent
        anchors.margins: 10

        front: RowLayout{
            anchors.fill: parent

            InformPanel{
                Layout.fillHeight: true
                width: 250

                onFullScreen: main.showFullScreen()
            }

            Rectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
