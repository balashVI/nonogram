import QtQuick 2.2

Item {
    id: crosswordBody
    property int columns
    property int rows
    property int cellsSize: 30
    property int cellSpacing: 2

    width: 10
    height: 10
    clip: true

    Flickable{
        id: flickable
        anchors.fill: parent
        contentHeight: rows*(cellsSize+cellSpacing)
        contentWidth: columns*(cellsSize+cellSpacing)

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
            }
        }

        Grid{
            anchors.fill: parent
            columns: crosswordBody.columns
            spacing: cellSpacing

            Repeater{
                model: list
                delegate: list_delegate
            }
        }

        onMovementStarted: {
            horizontal_scroll.state = "visible"
            vertical_scroll.state = "visible"
        }

        onMovementEnded: {
            horizontal_scroll.state = "invisible"
            vertical_scroll.state = "invisible"
        }
    }
    Scroll{
        id: horizontal_scroll
        obj: flickable
        isHorizontal: true
        isTwoScrolls: true
    }
    Scroll{
        id: vertical_scroll
        obj: flickable
        isHorizontal: false
        isTwoScrolls: true
    }

    function init(vColumns,vRows){
        rows = vRows
        columns = vColumns

        list.clear()
        for(var i=0;i<rows*columns;i++)
            list.append({})
    }
}
