import QtQuick 2.2
import QtQuick.LocalStorage 2.0

Item{
    id: main

    property int numberOfCrosswords: 0
    property int numberOfUnsolvedСrosswords: 0
    property int numberOfSolvedСrosswords: 0
    property int numberOfStartedСrosswords: 0

    property int currentCrossword: -1
    property int currentCrosswordStatus: -1

    Column{
        anchors.fill: parent

        Text{
            id: header
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 20
            height: 35
            text: qsTr("Список головоломок")
        }

        ListModel{
            id: listModel
            Component.onCompleted: main.updateContent()
        }

        ListView{
            id: view
            width: parent.width
            height: parent.height - header.height

            onCurrentIndexChanged:
                main.setCurrentCrossword(listModel.get(currentIndex).crossword_id, listModel.get(currentIndex).status)

            clip: true
            spacing: 1
            currentIndex: - 1

            model: listModel
            delegate: listDelegate

            section.property: "status"
            section.delegate: Text{
                x: 20
                height: 30
                font.pixelSize: 20
                font.italic: true
                text: if(section==0) qsTr("Не розв'язані")
                      else if(section==1) qsTr("Розпочаті")
                      else qsTr("Розв'язані")
            }

            onMovementStarted: scroll.state = "visible"
            onMovementEnded: scroll.state = "invisible"

            Scroll{
                id: scroll
                isHorizontal: false
                obj: view
            }
        }

        Component{
            id:listDelegate
            Rectangle{
                width: view.width
                height: 80
                border.color: "gray"
                border.width: ListView.isCurrentItem ? 3 : 1
                color: ListView.isCurrentItem ? "#F2F2F2" : "white"

                MouseArea{
                    anchors.fill: parent
                    onClicked: view.currentIndex = model.index
                }

                Text{
                    x: 5
                    y: 5
                    font.italic: true
                    text: (model.index+1) + qsTr(" з ") + listModel.count
                }


                Text{
                    y:5
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Головоломка №") + model.crossword_id
                }
                Text{
                    y: 30
                    x: 5
                    text: qsTr("Довжина ") + model.width + qsTr(", висота ") + model.height
                }
                Text{
                    x: 5
                    y: 55
                    text: qsTr("Час, потрачений на розв'язання: ") + model.time
                }
            }
        }
    }

    function updateContent(){
        listModel.clear()
        var db = mainWindow.getDB()
        if(!db) {
            console.error("Can not open DB!")
            Qt.quit()
        }
        db.transaction(function (tx){
            var res = tx.executeSql("SELECT crossword_id, width, height, time, status FROM crosswords" +
                                    " WHERE status = 1")
            numberOfStartedСrosswords = res.rows.length
            for(var i=0;i<res.rows.length;i++) listModel.append(res.rows.item(i))
            res = tx.executeSql("SELECT crossword_id, width, height, time, status FROM crosswords" +
                                " WHERE status = 0")
            numberOfUnsolvedСrosswords = res.rows.length
            for(var i=0;i<res.rows.length;i++) listModel.append(res.rows.item(i))
            res = tx.executeSql("SELECT crossword_id, width, height, time, status FROM crosswords" +
                                " WHERE status = 2")
            numberOfSolvedСrosswords = res.rows.length
            for(var i=0;i<res.rows.length;i++) listModel.append(res.rows.item(i))
            numberOfCrosswords = numberOfStartedСrosswords+numberOfUnsolvedСrosswords+numberOfSolvedСrosswords
        })
    }

    function setCurrentCrossword(id, status){
        currentCrossword = id
        currentCrosswordStatus = status
    }
}
