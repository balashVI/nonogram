import QtQuick 2.2

Item {
    property int value: minValue+(sliderPoint.x/sliderBackground.width)*(maxValue-minValue)
    property int maxValue: 60
    property int minValue: 20
    property int size: 8

    height:20

    Rectangle{
        id: sliderBackground
        width: parent.width-size*2
        radius: size/2
        anchors.horizontalCenter: parent.horizontalCenter
        height: size/2
        anchors.verticalCenter: parent.verticalCenter
        color: "lightgray"
    }

    Rectangle{
        id: sliderPoint
        width: size*2
        height: size*2
        radius: size
        anchors.verticalCenter: parent.verticalCenter
        color: "black"
        opacity: 0.6

        MouseArea{
            anchors.fill: parent
            drag.target: parent
            drag.minimumX: 0
            drag.maximumX: sliderBackground.width
        }
    }
}
