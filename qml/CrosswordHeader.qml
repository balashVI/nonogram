import QtQuick 2.2
import QtQuick.Layouts 1.1

Item {
    id: crosswordHeader

    property int columns
    property int rows
    property int cellsSize: 30
    property int cellSpacing: 2
    property string dataStr
    property int contentPosition: 0
    property int orientation: Qt.Vertical

    Flickable{
        anchors.fill: parent
        contentHeight: rows*(cellsSize+cellSpacing)
        contentWidth: columns*(cellsSize+cellSpacing)
        interactive: false
        clip: true

        contentX: (orientation==Qt.Horizontal)?contentPosition:0
        contentY: (orientation==Qt.Vertical)?contentPosition:0

        ListModel{
            id: list
        }

        Component{
            id: list_delegate

            Rectangle{
                width: cellsSize
                height: cellsSize
                border.color: "gray"

                state: "Normal"

                Text{
                    anchors.centerIn: parent
                    text: model.data
                    renderType: Text.NativeRendering
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(model.data!="")
                            parent.state = (parent.state=="Normal")?"CrossOut":"Normal"
                    }
                }
                Rectangle{
                    id: crossOut
                    anchors.centerIn: parent
                    width: cellSize
                    height: cellSize / 6
                    radius: cellSize / 12
                    rotation: -45
                    opacity: 0.5
                    color: "red"
                }

                states: [State{
                        name: "Normal"
                        PropertyChanges{
                            target: crossOut
                            visible: false
                        }
                    },
                    State{
                        name: "CrossOut"
                        PropertyChanges{
                            target: crossOut
                            visible: true
                        }
                    }
                ]
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

        Repeater{
            model: Math.ceil(columns/5-1)
            delegate: Rectangle{
                width:2
                height: parent.height
                x: (model.index+1)*(crosswordHeader.cellsSize+crosswordHeader.cellSpacing)*5-crosswordHeader.cellSpacing
                color: "gray"
                opacity: 0.5
            }
        }

        Repeater{
            model: Math.ceil(rows/5-1)
            delegate: Rectangle{
                width: parent.width
                height: 2
                y: (model.index+1)*(crosswordHeader.cellsSize+crosswordHeader.cellSpacing)*5-crosswordHeader.cellSpacing
                color: "gray"
                opacity: 0.5
            }
        }
    }

    function init(vColumns,vRows, vData){
        rows = vRows
        columns = vColumns

        list.clear()

        if(orientation==Qt.Vertical){
            for(var i=0;i<rows;i++)
                for(var j=0;j<columns;j++){
                    if(j<columns-vData[i].length)
                        list.append({data: ""})
                    else
                        list.append({data: String(vData[i][j-(columns-vData[i].length)])})
                }
        } else {
            for(var i=0;i<rows;i++)
                for(var j=0;j<columns;j++){
                    if(i<rows-vData[j].length)
                        list.append({data: ""})
                    else
                        list.append({data: String(vData[j][i-(rows-vData[j].length)])})
                }
        }
    }
}
