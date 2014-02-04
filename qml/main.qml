import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

import "qrc:/qml/"

Window {
    id: main
    width: 800
    height: 500

    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        Header{
        }

        Rectangle{
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "blue"
        }
    }
}
