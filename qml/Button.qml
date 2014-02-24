import QtQuick 2.2

Item {
    id: main
    state: "normal"
    property string text: ""

    signal clicked

    Rectangle{
        id: background

        anchors{
            fill: parent

        }
        radius: 5

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true

            onEntered: main.state = "mouseOver"
            onExited: main.state = "normal"
            onPressedChanged: {
                if(pressed)
                    main.state = "pressed"
                else {
                    main.clicked()
                    main.state = "normal"
                }
            }
        }
    }

    Text{
        id: txt
        anchors.centerIn: parent
        renderType: Text.NativeRendering
        text: parent.text
    }

    states: [
        State {
            name: "normal"
            PropertyChanges{
                target: background;
                opacity: 0.5
                color: "lightgray"
            }
            PropertyChanges {
                target: txt
                color: "black"
            }
        },
        State {
            name: "mouseOver"
            PropertyChanges{
                target: background;
                opacity: 1
                color: "lightgray"
            }
        },
        State {
            name: "pressed"
            PropertyChanges{
                target: background;
                opacity: 1
                color: "darkgray"
            }
            PropertyChanges {
                target: txt
                color: "white"
            }
        }
    ]
}
