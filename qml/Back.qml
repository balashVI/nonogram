import QtQuick 2.2
import QtQuick.Layouts 1.1

Rectangle {
    id: back

    property int time: 0
    property int crosswordId: 0
    property int crosswordRows: 11
    property int crosswordColumns: 5
    property int topHeaderLevel: 2
    property int leftHeaderLevel: 2

    property int cellSize: cellSizeSlider.value

    signal goFront

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

            Column{
                width: parent.width
                spacing: 5
                Text{
                    id: crosswor_id_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    renderType: Text.NativeRendering
                    text: qsTr("Головоломка №") + crosswordId
                }

                Text{
                    renderType: Text.NativeRendering
                    text: qsTr("Розмір клітинок")
                }

                Slider{
                    id: cellSizeSlider
                    width: parent.width
                }

                Button{
                    text: qsTr("Повернутися")
                    width: parent.width
                    height: 30
                }
            }

            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                font.pixelSize: 40
                text: time
            }
        }

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true

            CrosswordHeader{
                id: topHeader
                anchors{
                    left: leftHeader.right
                    right: parent.right
                    top: parent.top
                    margins: 10
                }
                height: (cellSpacing+back.cellSize)*topHeaderLevel-cellSpacing
                contentPosition: body.contentX
                orientation: Qt.Horizontal
                cellsSize: back.cellSize
            }

            CrosswordHeader{
                id: leftHeader
                anchors{
                    left: parent.left
                    top: topHeader.bottom
                    bottom: parent.bottom
                    margins: 10
                }
                width: (cellSpacing+back.cellSize)*leftHeaderLevel-cellSpacing
                contentPosition: body.contentY
                orientation: Qt.Vertical
                cellsSize: back.cellSize
            }

            CrosswordBody{
                id: body
                anchors{
                    left: leftHeader.right
                    right: parent.right
                    top: topHeader.bottom
                    bottom: parent.bottom
                    margins: 10
                }
                cellsSize: back.cellSize
            }
        }
    }

    Component.onCompleted: init()

    function init(){
        var columns = 6
        var rows = 6
        var originalData = "110010010000001000000100000001010101"
        var data = "112010212000021200002120000001313131"

        // Обчислення даних для лівої частини головоломки
        var isZero
        var count
        leftHeaderLevel = 0

        var leftHeaderData = new Array()
        for(var i=0;i<rows;i++)
            leftHeaderData.push(new Array())
        for(var i=0;i<rows;i++){
            isZero = true
            count = 0
            for(var j=0;j<columns;j++){
                if(originalData[i*columns+j]=="1"){
                    count++
                    if(isZero)
                        isZero=false
                } else if(!isZero) {
                    isZero = true
                    leftHeaderData[i].push(count)
                    count=0
                }
            }
            if(!isZero)
                leftHeaderData[i].push(count)
            if(leftHeaderData[i].length>leftHeaderLevel)
                leftHeaderLevel = leftHeaderData[i].length
        }

        // Обчислення даних для верхньої частини головоломки
        topHeaderLevel = 0
        var topHeaderData = new Array()
        for(var i=0;i<rows;i++)
            topHeaderData.push(new Array())
        for(var i=0;i<columns;i++){
            isZero = true
            count = 0
            for(var j=0;j<rows;j++){
                if(originalData[j*columns+i]=="1"){
                    count++
                    if(isZero)
                        isZero=false
                } else if(!isZero) {
                    isZero = true
                    topHeaderData[i].push(count)
                    count=0
                }
            }
            if(!isZero)
                topHeaderData[i].push(count)
            if(topHeaderData[i].length>topHeaderLevel)
                topHeaderLevel = topHeaderData[i].length
        }

        body.init(columns, rows, data)
        leftHeader.init(leftHeaderLevel, rows, leftHeaderData)
        topHeader.init(columns, topHeaderLevel, topHeaderData)
    }
}
