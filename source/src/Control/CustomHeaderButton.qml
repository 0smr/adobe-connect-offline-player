import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Button {
    id: control

    width: 25;
    height: width;

    property color color: '#333';
    property alias forground: fg;

    background: Rectangle {
        opacity: control.hovered ? 1 : 0;
        color: control.color;
    }

    contentItem: Text {
        id: fg
        text: control.text;
        font: control.font;
        opacity: enabled ? 1.0 : 0.3;
        color: control.pressed ? "#ddd" : "#fff";
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
    }
}
