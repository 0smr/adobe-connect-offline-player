import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Button {
    id: control

    width: 25
    height: width

    background: Rectangle {
        radius: control.width / 2;
        opacity: 0.7

        Rectangle {
            id: indicator
            anchors.centerIn: parent
            color: '#39B2E6'

            width: control.pressed ? control.width : 0
            height: width;
            radius: width /2;
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.pressed ? "#fff" : "#bbb"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    ParallelAnimation {
        id: clickAnim
        NumberAnimation {
            target: indicator;
            property: "width";
            from: 0;to: control.width;
            duration: 200;
        }
        NumberAnimation {
            target: indicator;
            property: "opacity";
            from:1;to: 0.5;
            duration: 350;
        }
    }

    onPressed: clickAnim.restart();
}
