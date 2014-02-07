import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.LocalStorage 2.0

import "../qml"
import "../js/functions.js" as Functions

Window {
    id: main
    width: 800
    height: 500
    minimumWidth: 800
    minimumHeight: 500
    title: "Nonogram"

    property var db
    property bool isMaximize: false

    Component.onCompleted: Functions.dbCreatingTables(db)

    Flipable{
        anchors.fill: parent
        anchors.margins: 10

        front: RowLayout{
            anchors.fill: parent

            InformPanel{
                Layout.fillHeight: true
                width: 250

                onStateChanged: {
                    if(state == "normalMode"){
                        if(isMaximize)
                            main.showMaximized()
                        else
                            main.showNormal()
                    }else{
                        main.isMaximize = (main.visibility == Window.Maximized)
                        main.showFullScreen()
                    }
                }

                numberOfCrosswords: listOfCrosswords.numberOfCrosswords
                numberOfSolvedСrosswords: listOfCrosswords.numberOfSolvedСrosswords
                numberOfStartedСrosswords: listOfCrosswords.numberOfStartedСrosswords
                numberOfUnsolvedСrosswords: listOfCrosswords.numberOfUnsolvedСrosswords
            }

            ListOfCrosswords{
                id: listOfCrosswords
                Layout.fillWidth: true
                Layout.fillHeight: true

                onCurrentCrosswordChanged: console.log(currentCrossword)
            }
        }
    }
}
