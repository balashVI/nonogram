import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
    Layout.fillWidth: true
    height: 40
    Rectangle{
        anchors.fill: parent
        color: "lightblue"

        MouseArea{
            anchors.fill: parent
            onClicked: {
                main.showFullScreen()
            }
        }
    }
}
