import QtQuick 2.2

Item{
    property bool isHorizontal: false
    property bool isTwoScrolls: false
    property Item obj: null
    property int thickness: 8
    property int margingValue: 1

    id: main
    state: "invisible"
    x: margingValue
    y: margingValue
    width: isHorizontal ? (isTwoScrolls ? obj.width - margingValue*2
                                          - thickness : obj.width - margingValue*2) : thickness
    height: isHorizontal ? thickness : (isTwoScrolls ? obj.height - margingValue*2
                                                     -thickness : obj.height - margingValue*2)

    anchors.bottom: if(isHorizontal) obj.bottom
    anchors.right: if(!isHorizontal) obj.right
    anchors.margins: 1

    Rectangle{
        id: background
        anchors.fill: parent
        color:"gray"

        opacity: 0.3

        radius: thickness/2
    }

    Rectangle{
        id: scroll

        property int widthVar : parent.width*obj.width/obj.contentWidth
        property int heightVar : parent.height*obj.height/obj.contentHeight

        width: isHorizontal ? (widthVar < 20 ? 20 : (widthVar > parent.width ? parent.width : widthVar)) : thickness
        height: isHorizontal ? thickness : (heightVar < 20 ? 20 : (heightVar > parent.height ? parent.height : heightVar))

        y: isHorizontal ? 0 : obj.visibleArea.yPosition * parent.height
        x: isHorizontal ? obj.visibleArea.xPosition * parent.width : 0

        color: "darkgray"
        opacity: 0.9

        radius: thickness/2
    }

    states: [
        State {
            name: "invisible"
            PropertyChanges {
                target: main
                opacity: 0
            }
        },
        State {
            name: "visible"
            PropertyChanges {
                target: main
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "invisible"
            to: "visible"
            NumberAnimation{
                target: main
                property: "opacity"
                duration: 250
            }
        },
        Transition {
            from: "visible"
            to: "invisible"
            NumberAnimation{
                target: main
                property: "opacity"
                duration: 1000
            }
        }
    ]
}
