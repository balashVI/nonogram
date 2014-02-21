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

    property var db
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
            anchors.fill: parent
            visible: parent.state == "front"
            onButtonPlay: flipable.state = "back"
        }

        back: Back{
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
        db = LocalStorage.openDatabaseSync("nonograDB", "1.0", "Nonogram Data Base", 10000000)
        if(!db) {
            console.error("Can not open DB!")
            Qt.quit()
        }

        db.transaction(
                    function(tx){
                        tx.executeSql("CREATE TABLE IF NOT EXISTS settings(property TEXT, value TEXT)")
                        var res = tx.executeSql("SELECT * FROM settings")
                        if(!res.rows.length){
                            tx.executeSql("INSERT INTO settings VALUES (\"language\", \"uk\")")
                            tx.executeSql("INSERT INTO settings VALUES (\"db_version\", \"0\")")
                        }
                        tx.executeSql("CREATE TABLE IF NOT EXISTS crosswords(crossword_id INT NOT NULL PRIMARY KEY, "+
                                      "width INT, height INT, crossword TEXT, user_crossword TEXT, progress FLOAT, "+
                                      "time INT, status INT)")
                    }
                    )
    }
}
