import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0

Item {
    property bool isFullScreen: false

    signal buttonPlay

    RowLayout{
        anchors.fill: parent
        Item{
            id: informPanel
            Layout.fillHeight: true
            width: 250

            property int previousCrossword: -1

            Column{
                spacing: 8
                width: parent.width
                Button{
                    width: parent.width
                    height: 40
                    visible: (listOfCrosswords.currentCrossword != -1)
                    text: {
                        if(listOfCrosswords.currentCrosswordStatus == 0)
                            qsTr("Розпочати гру")
                        else if(listOfCrosswords.currentCrosswordStatus == 1)
                            qsTr("Продовжити гру")
                        else qsTr("Переглянути розв'язок")
                    }
                    onClicked: buttonPlay()
                }
                Button{
                    width: parent.width
                    height: 40
                    visible: (listOfCrosswords.currentCrosswordStatus == 1)||(listOfCrosswords.currentCrosswordStatus == 2)
                    text: qsTr("Розпочати заново")
                }
                Button{
                    width: parent.width
                    height: 40
                    visible: (listOfCrosswords.previousCrossword != -1)
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
                    text: listOfCrosswords.numberOfCrosswords
                }

                Text{
                    text: qsTr("розв'язаних: ")
                }

                Text{
                    text: listOfCrosswords.numberOfSolvedСrosswords
                }

                Text{
                    text: qsTr("не розв'язаних: ")
                }

                Text{
                    text: listOfCrosswords.numberOfUnsolvedСrosswords
                }

                Text{
                    text: qsTr("розпочатих: ")
                }

                Text{
                    text: listOfCrosswords.numberOfStartedСrosswords
                }

                Button{
                    id: fullScreenButton
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    height: 30
                }

                Button{
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    height: 30

                    text: qsTr("Налаштування")
                }
            }

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

        ListOfCrosswords{
            id: listOfCrosswords
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
