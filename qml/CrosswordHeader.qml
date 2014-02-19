import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
    id: crosswordHeader

    property int columns
    property int rows
    property int cellsSize: 30
    property int cellSpacing: 2
    property string dataStr

    Flickable{
        anchors.fill: parent
        contentHeight: rows*(cellsSize+cellSpacing)
        contentWidth: columns*(cellsSize+cellSpacing)
        interactive: false
        clip: true

        ListModel{
            id: list
        }

        Component{
            id: list_delegate

            Rectangle{
                property bool isClicked: false
                width: cellsSize
                height: cellsSize
                border.color: "gray"               

                Text{
                    anchors.centerIn: parent
                    text: model.index
                    color: parent.isClicked?"red":"black"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: parent.isClicked = !parent.isClicked
                }
            }
        }

        Grid{
            anchors.fill: parent
            columns: crosswordHeader.columns
            spacing: cellSpacing

            Repeater{
                model: list
                delegate: list_delegate
            }
        }
    }

    function init(vColumns,vRows){
        rows = vRows
        columns = vColumns

        list.clear()
        for(var i=0;i<rows*columns;i++)
            list.append({})
    }
}
