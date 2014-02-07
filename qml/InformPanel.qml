import QtQuick 2.2
import QtQuick.Layouts 1.1

import "../qml"

Item{
    id: main
    state: "normalMode"

    property int numberOfCrosswords: 0
    property int numberOfUnsolvedСrosswords: 0
    property int numberOfSolvedСrosswords: 0
    property int numberOfStartedСrosswords: 0

    property bool isFullScreen: false

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
}
