import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0

import "../qml"

Item{
    id: main
    state: "normalMode"

    property int numberOfCrosswords: 0
    property int numberOfUnsolvedСrosswords: 0
    property int numberOfSolvedСrosswords: 0
    property int numberOfStartedСrosswords: 0

    property int currentCrossword: -1
    property int currentCrosswordStatus: -1
    property int previousCrossword

    property bool isFullScreen: false

    Column{
        spacing: 8
        width: parent.width
        Button{
            width: parent.width
            height: 40
            visible: (currentCrossword != -1)
            text: {
                if(currentCrosswordStatus == 0)
                    qsTr("Розпочати гру")
                else if(currentCrosswordStatus == 1)
                    qsTr("Продовжити гру")
                else qsTr("Переглянути розв'язок")
            }
        }
        Button{
            width: parent.width
            height: 40
            visible: (currentCrosswordStatus == 1)||(currentCrosswordStatus == 2)
            text: qsTr("Розпочати заново")
        }
        Button{
            width: parent.width
            height: 40
            visible: (previousCrossword != -1)
            text: qsTr("Продовжити попередню гру")
        }
    }

    GridLayout{
        width: parent.width
        anchors.bottom: parent.bottom
        columns: 2

        Text{
            Layout.columnSpan: 2
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            text: qsTr("Кількість головоломок")
        }

        Text{
            text: qsTr("усіх: ")
        }

        Text{
            text: numberOfCrosswords
        }

        Text{
            text: qsTr("розв'язаних: ")
        }

        Text{
            text: numberOfSolvedСrosswords
        }

        Text{
            text: qsTr("не розв'язаних: ")
        }

        Text{
            text: numberOfUnsolvedСrosswords
        }

        Text{
            text: qsTr("розпочатих: ")
        }

        Text{
            text: numberOfStartedСrosswords
        }

        Button{
            id: fullScreenButton
            Layout.fillWidth: true
            Layout.columnSpan: 2
            height: 30

            onClicked: {
                if(isFullScreen){
                    main.state = "normalMode"
                    isFullScreen = false
                } else {
                    main.state = "fullScreen"
                    isFullScreen = true
                }
            }
        }

        Button{
            Layout.fillWidth: true
            Layout.columnSpan: 2
            height: 30

            text: qsTr("Налаштування")
        }
    }

    states: [
        State{
            name: "normalMode"
            PropertyChanges {
                target: fullScreenButton
                text: qsTr("Повноекранний режим")
            }
        },
        State{
            name: "fullScreen"
            PropertyChanges {
                target: fullScreenButton
                text: qsTr("Нормальний режим")
            }
        }
    ]

    Component.onCompleted: {
        //Отримання індексу поппереднього відкритого кросворду
        var db = LocalStorage.openDatabaseSync("nonograDB", "1.0", "Nonogram Data Base", 10000000)
        if(!db) {
            console.error("Can not open DB!")
            Qt.quit()
        }
        db.transaction(
                    function(tx){
                        var res = tx.executeSql("select value from settings where property='lastOpenedCrossword'")
                        if(res.rows.length == 0) previousCrossword = -1
                        else {
                            previousCrossword = res.rows.item(0).value
                            res = tx.executeSql("select status from crosswords where crossword_id='"+
                                                previousCrossword.toString() + "'")
                            if(res.rows.length)
                                if(res.rows.item(0).status != "1") previousCrossword = -1
                        }
                    })
    }
}
