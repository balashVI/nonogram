import QtQuick 2.0
import QtQuick.Layouts 1.1

import "../qml"

Item{
    id: main

    property int numberOfCrosswords: 0
    property int numberOfUnsolvedСrosswords: 0
    property int numberOfSolvedСrosswords: 0
    property int numberOfStartedСrosswords: 0

    property bool isFullScreen: false

    signal fullScreen
    signal normalMode

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
            Layout.fillWidth: true
            Layout.columnSpan: 2
            height: 30

            text: qsTr("На весь екран")

            onClicked: main.fullScreen()
        }

        Button{
            Layout.fillWidth: true
            Layout.columnSpan: 2
            height: 30

            text: qsTr("Налаштування")
        }
    }
}
