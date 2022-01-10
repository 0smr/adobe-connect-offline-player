import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: control

    property color color: '#1fc1bc'

    width: 25
    height: width

    background: Rectangle {
        radius: 2;
        color: '#221fc1bc';
        clip: true;

        Rectangle {
            id: indicator

            x: mArea.mouseX-width/2
            y: mArea.mouseY-height/2

            color: '#1fc1bc'
            opacity: 0.3

            height: width;
            radius: width /2;
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.color
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mArea
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
    }

    ParallelAnimation {
        id: clickAnim
        NumberAnimation {
            target: indicator;
            property: "width";
            from: 0;to: control.width * 2.5;
            duration: 500;
        }
        NumberAnimation {
            target: indicator;
            property: "opacity";
            from: 0.3;to: 0;
            duration: 1000;
        }
    }

    onPressed:{
        clickAnim.restart();
    }
}
