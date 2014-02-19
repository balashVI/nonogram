import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.LocalStorage 2.0

import "../qml"
import "../js/functions.js" as Functions

Window {
    id: main
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

        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
            angle: 180    // the default angle
        }

        front: Rectangle {
            RowLayout{
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

                    currentCrossword: listOfCrosswords.currentCrossword
                    currentCrosswordStatus: listOfCrosswords.currentCrosswordStatus
                }

                ListOfCrosswords{
                    id: listOfCrosswords
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    onCurrentCrosswordChanged: console.log(currentCrossword)
                }
            }
        }

        back: Back{
            anchors.fill: parent
        }
    }

    Component.onCompleted: Functions.dbCreatingTables(db)
}
