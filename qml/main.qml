import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.LocalStorage 2.0

import "qrc:/qml/"

Window {
    id: mainWindow
    width: 1000
    height: 700
    minimumWidth: 1000
    minimumHeight: 700
    title: "Nonogram"

    property int dbVersion
    property bool isMaximize: false

    Flipable{
        id: flipable
        anchors.fill: parent
        anchors.margins: 10

        state: "front"

        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0
            angle: 0
        }

        front: Front {
            id: frontElement
            anchors.fill: parent
            visible: parent.state == "front"
            onBeginGame:{
                backElement.init(crosswordId, crosswordStatus)
                flipable.state = "back"
            }

        }

        back: Back{
            id: backElement
            anchors.fill: parent
            onGoFront: {
                flipable.state = "front"
            }
            visible: parent.state == "back"
        }

        states: [
            State{
                name: "front"
                PropertyChanges {
                    target: rotation
                    angle: 0
                }
            },
            State{
                name: "back"
                PropertyChanges {
                    target: rotation
                    angle: 180
                }
            }
        ]
    }

    Component.onCompleted: {
        var db = getDB()
        if(!db) {
            console.error("Can not open DB!")
            Qt.quit()
        }

        //Створення таблиць в локальній БД якщо вони не існують, отримання поточної версії БД
        db.transaction(
                    function(tx){
                        tx.executeSql("CREATE TABLE IF NOT EXISTS settings(property TEXT, value TEXT)")
                        var res = tx.executeSql("SELECT * FROM settings")
                        if(!res.rows.length){
                            tx.executeSql("INSERT INTO settings VALUES (\"language\", \"uk\")")
                            tx.executeSql("INSERT INTO settings VALUES (\"db_version\", \"0\")")
                        }
                        tx.executeSql("CREATE TABLE IF NOT EXISTS crosswords(crossword_id INT NOT NULL PRIMARY KEY, "+
                                      "width INT, height INT, crossword TEXT, user_crossword TEXT, "+
                                      "time INT, status INT)")
                        res = tx.executeSql("SELECT value FROM settings WHERE property=\"db_version\"")
                        if(res.rows.length)
                            dbVersion = res.rows.item(0).value
                    }
                    )

        //Отримання найновішої БД
        var request = new XMLHttpRequest()
        request.open("POST", "http://drupalhost.ca/nonogram_api.php", true)
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
        request.onreadystatechange = function(){
            if(request.readyState === XMLHttpRequest.DONE){
                if(request.status === 200){
                    var requestRes = JSON.parse(request.responseText)

                    //Видалення головоломок яких немає у новій версії БД
                    db.transaction(
                                function(tx){
                                    var sqlRes = tx.executeSql("SELECT crossword_id FROM crosswords ORDER BY crossword_id")
                                    var j = requestRes.data.length-1
                                    for(var i=0;i<sqlRes.rows.length;i++){
                                        if((sqlRes.rows.item(i).crossword_id<requestRes.data[j].id)||(j<0))
                                            tx.executeSql("DELETE FROM crosswords WHERE crossword_id='"+sqlRes.rows.item(i).crossword_id+"'")
                                        else if(sqlRes.rows.item(i).crossword_id==requestRes.data[j].id)
                                            j--
                                        else if(sqlRes.rows.item(i).crossword_id>requestRes.data[j].id){
                                            tx.executeSql("INSERT INTO crosswords VALUES(?,?,?,?,?,?,?)",
                                                          [requestRes.data[j].id, requestRes.data[j].width, requestRes.data[j].height,
                                                           requestRes.data[j].crossword, "", 0, 0])
                                            j--
                                        }
                                    }
                                    for(;j>=0;j--)
                                        tx.executeSql("INSERT INTO crosswords VALUES(?,?,?,?,?,?,?)",
                                                      [requestRes.data[j].id, requestRes.data[j].width, requestRes.data[j].height,
                                                       requestRes.data[j].crossword, "", 0, 0])
                                    frontElement.updateListOfCrosswords()
                                }
                                )
                } else {
                    console.error("Не вдалося з'єднатися з віддаленою БД", request.status)
                }
            }
        }
        var params = "mode=import&db_version=0"
        request.send(params)
    }

    function getDB(){
        return LocalStorage.openDatabaseSync("nonograDB", "1.0", "Nonogram crossword Base", 10000000);
    }
}
