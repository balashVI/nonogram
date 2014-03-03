import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0

Rectangle {
    id: back

    property int time: 0
    property int crosswordId: 0
    property int crosswordRows: 0
    property int crosswordColumns: 0
    property int topHeaderLevel: 0
    property int leftHeaderLevel: 0

    property int cellSize: cellSizeSlider.value
    property string crossword: ""
    property string originalCrossword: ""
    property int trueCellsCount: 0
    property int userTrueCellsCount: 0

    signal goFront();

    Timer{
        id: timer
        repeat: true
        interval: 1000
        onTriggered: time++
        running: false
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

                onCellStateChanged: {
                    crossword[i] = currentState
                    if(originalCrossword[i]==="1"){
                        if( (previousState===stateDontKnow)&&(currentState===stateYes)||
                                (previousState===stateDontKnow)&&(currentState===stateMaybe)||
                                (previousState===stateNo)&&(currentState===stateYes)||
                                (previousState===stateNo)&&(currentState===stateMaybe))
                            userTrueCellsCount++
                        else if( (previousState===stateYes)&&(currentState===stateDontKnow)||
                                    (previousState===stateYes)&&(currentState===stateNo)||
                                    (previousState===stateMaybe)&&(currentState===stateDontKnow)||
                                    (previousState===stateMaybe)&&(currentState===stateNo))
                            userTrueCellsCount--
                    } else {
                        if( (previousState===stateDontKnow)&&(currentState===stateYes)||
                                (previousState===stateDontKnow)&&(currentState===stateMaybe)||
                                (previousState===stateNo)&&(currentState===stateYes)||
                                (previousState===stateNo)&&(currentState===stateMaybe))
                            userTrueCellsCount--
                        else if( (previousState===stateYes)&&(currentState===stateDontKnow)||
                                    (previousState===stateYes)&&(currentState===stateNo)||
                                    (previousState===stateMaybe)&&(currentState===stateDontKnow)||
                                    (previousState===stateMaybe)&&(currentState===stateNo))
                            userTrueCellsCount++
                    }
                    if(userTrueCellsCount===trueCellsCount){
                        body.init(crosswordColumns, crosswordRows, originalCrossword)
                        body.canEdit = false
                        leftHeader.canEdit = false
                        topHeader.canEdit = false
                    }
                }
            }
        }
    }

    function init(crosswordId, crosswordStatus){
        var db = mainWindow.getDB()
        if(!db) {
            console.error("Can not open DB!")
            Qt.quit()
        }
        db.transaction(
                    function(tx){
                        var res = tx.executeSql("SELECT width, height, crossword, user_crossword, time "+
                                                "FROM crosswords WHERE crossword_id='"+crosswordId+"'")
                        if(res.rows.length){
                            back.crosswordColumns = res.rows.item(0).width
                            back.crosswordRows = res.rows.item(0).height
                            back.originalCrossword = res.rows.item(0).crossword
                            if(crosswordStatus === 0){
                                back.crossword = ""
                                for(var i=0;i<back.crosswordColumns*back.crosswordRows;i++)
                                    back.crossword += "0"
                            } else {
                                back.crossword = res.crosswordRows.item(0).user_crossword
                                back.time = res.crosswordRows.item(0).time
                            }
                        } else {
                            Qt.quit()
                        }
                    }
                    )

        //Обчислення загальної кількіості "закрашених" клітонок
        trueCellsCount = 0
        userTrueCellsCount = 0
        for(var i=0; i<crossword.length; i++){
            if(originalCrossword[i]==="1") trueCellsCount++
            if(crossword[i]==="1") userTrueCellsCount++
        }

        // Обчислення даних для лівої частини головоломки
        var isZero
        var count
        back.leftHeaderLevel = 0

        var leftHeadercrossword = new Array()
        for(var i=0;i<back.crosswordRows;i++)
            leftHeadercrossword.push(new Array())
        for(var i=0;i<back.crosswordRows;i++){
            isZero = true
            count = 0
            for(var j=0;j<back.crosswordColumns;j++){
                if(back.originalCrossword[i*back.crosswordColumns+j]=="1"){
                    count++
                    if(isZero)
                        isZero=false
                } else if(!isZero) {
                    isZero = true
                    leftHeadercrossword[i].push(count)
                    count=0
                }
            }
            if(!isZero)
                leftHeadercrossword[i].push(count)
            if(leftHeadercrossword[i].length>back.leftHeaderLevel)
                back.leftHeaderLevel = leftHeadercrossword[i].length
        }

        // Обчислення даних для верхньої частини головоломки
        back.topHeaderLevel = 0
        var topHeadercrossword = new Array()
        for(var i=0;i<back.crosswordRows;i++)
            topHeadercrossword.push(new Array())
        for(var i=0;i<back.crosswordColumns;i++){
            isZero = true
            count = 0
            for(var j=0;j<back.crosswordRows;j++){
                if(back.originalCrossword[j*back.crosswordColumns+i]=="1"){
                    count++
                    if(isZero)
                        isZero=false
                } else if(!isZero) {
                    isZero = true
                    topHeadercrossword[i].push(count)
                    count=0
                }
            }
            if(!isZero)
                topHeadercrossword[i].push(count)
            if(topHeadercrossword[i].length>back.topHeaderLevel)
                back.topHeaderLevel = topHeadercrossword[i].length
        }

        body.init(back.crosswordColumns, back.crosswordRows, crossword)
        leftHeader.init(back.leftHeaderLevel, back.crosswordRows, leftHeadercrossword)
        topHeader.init(back.crosswordColumns, back.topHeaderLevel, topHeadercrossword)

        if(crosswordStatus === 2){
            body.canEdit = false
            leftHeader.canEdit = false
            topHeader.canEdit = false
        } else {
            body.canEdit = true
            leftHeader.canEdit = true
            topHeader.canEdit = true
            timer.running = true
        }
        back.crosswordId = crosswordId
    }
}
