import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Button {
    id: control

    background: Rectangle {
        radius: control.width / 2;
        opacity: 0.7

        Rectangle {
            anchors.centerIn: parent
            color: '#39B2E6'

            width: control.pressed ? control.width : 0
            height: width;
            radius: width /2;

            Behavior on width {
                NumberAnimation{ duration: 200;}
            }
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.pressed ? "#fff" : "#bbb"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
