import QtQuick 2.2
import QtQuick.Layouts 1.1
import "./"

Rectangle {

    property int time: 0
    property int crosswordId: 0
    property int crosswordRows: 50
    property int crosswordColumns: 50
    property int topHeaderLevel: 5
    property int leftHeaderLevel: 5

    Timer{
        id: timer
        repeat: true
        interval: 1000
        onTriggered: time++
        running: true
    }


    RowLayout{
        anchors.fill: parent
        Item{
            Layout.fillHeight: true
            width: 250

            Text{
                id: crosswor_id_text
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                renderType: Text.NativeRendering
                text: qsTr("Головоломка №") + crosswordId
            }

            Button{
                text: qsTr("Повернутися")
                width: parent.width
                height: 30
                anchors.top: crosswor_id_text.bottom
                anchors.margins: 5
            }

            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                font.pixelSize: 40
                text: time
            }
        }

        GridLayout{
            Layout.fillHeight: true
            Layout.fillWidth: true
            columns: 2

            Rectangle{
                width: leftHeader.width
                height: leftHeader.height
            }

            CrosswordHeader{
                id: topHeader
                Layout.fillWidth: true
                height: (cellSpacing+cellsSize)*topHeaderLevel-cellSpacing
                Component.onCompleted: init(crosswordColumns,topHeaderLevel)
            }

            CrosswordHeader{
                id: leftHeader
                Layout.fillHeight: true
                width: (cellSpacing+cellsSize)*leftHeaderLevel-cellSpacing
                Component.onCompleted: init(leftHeaderLevel,crosswordRows)
            }

            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                CrosswordBody{
                    anchors.fill: parent
                    Component.onCompleted: init(crosswordColumns,crosswordRows)
                }
            }
        }
    }
}
