import QtQuick 2.2

Item {
    id: crosswordBody
    property int columns
    property int rows
    property int cellsSize: 30
    property int cellSpacing: 2
    property int contentX: flickable.contentX
    property int contentY: flickable.contentY

    // Стани комірок головоломки
    readonly property string stateDontKnow: "0"
    readonly property string stateYes: "1"
    readonly property string stateMaybe: "2"
    readonly property string stateNo: "3"

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
                id: cellBack
                property bool isClicked: false
                width: cellsSize
                height: cellsSize
                border.color: "gray"

                Rectangle{
                    id:cellPoint
                    radius: cellSize/8
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        switch(mouse.button){
                        case Qt.RightButton:
                            switch(model.data){
                            case stateDontKnow:
                                cellBack.state = "No"
                                list.setProperty(model.index, "data", stateNo)
                                break
                            default:
                                cellBack.state = "DontKnow"
                                list.setProperty(model.index, "data", stateDontKnow)
                                break
                            }
                            break
                        case Qt.LeftButton:
                            switch(model.data){
                            case stateMaybe:
                                cellBack.state = "Yes"
                                list.setProperty(model.index, "data", stateYes)
                                break
                            default:
                                cellBack.state = "Maybe"
                                list.setProperty(model.index, "data", stateMaybe)
                                break
                            }
                        }
                    }
                }

                Component.onCompleted: {
                    if(model.data == stateDontKnow)
                        state = "DontKnow"
                    else if(model.data == stateYes)
                        state = "Yes"
                    else if(model.data == stateMaybe)
                        state = "Maybe"
                    else
                        state = "No"
                }

                states: [
                    State {
                        name: "Yes"
                        PropertyChanges {
                            target: cellBack
                            color: "gray"
                        }
                        PropertyChanges {
                            target: cellPoint
                            visible: false
                        }
                    },
                    State {
                        name: "No"
                        PropertyChanges {
                            target: cellBack
                            color: "white"
                        }
                        PropertyChanges {
                            target: cellPoint
                            visible: true
                            color: "lightblue"
                            width: cellSize / 4
                            height: cellSize / 4
                            rotation: 0
                        }
                    },
                    State {
                        name: "Maybe"
                        PropertyChanges {
                            target: cellBack
                            color: "white"
                        }
                        PropertyChanges {
                            target: cellPoint
                            visible: true
                            color: "gray"
                            width: cellSize
                            height: cellSize / 6
                            rotation: -45
                        }
                    },
                    State {
                        name: "DontKnow"
                        PropertyChanges {
                            target: cellBack
                            color: "white"
                        }
                        PropertyChanges {
                            target: cellPoint
                            visible: false
                        }
                    }
                ]
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

        Repeater{
            model: Math.ceil(columns/5-1)
            delegate: Rectangle{
                width:2
                height: parent.height-2
                x: (model.index+1)*(crosswordBody.cellsSize+crosswordBody.cellSpacing)*5-crosswordBody.cellSpacing
                color: "gray"
                opacity: 0.5
            }
        }

        Repeater{
            model: Math.ceil(rows/5-1)
            delegate: Rectangle{
                width: parent.width-2
                height: 2
                y: (model.index+1)*(crosswordBody.cellsSize+crosswordBody.cellSpacing)*5-crosswordBody.cellSpacing
                color: "gray"
                opacity: 0.5
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

    function init(vColumns,vRows, vData){
        rows = vRows
        columns = vColumns

        list.clear()
        for(var i=0;i<rows*columns;i++)
            list.append({data: vData[i]})
    }
}
