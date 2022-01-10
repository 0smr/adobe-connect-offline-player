import QtQuick 2.12
import QtQuick.Controls 2.12

TextArea {
    id: control
    color: '#222'

    property var indicator: indicator

    padding: 0;

    background: Rectangle {

        implicitWidth: 100;
        implicitHeight: 20;
        color: control.enabled ? "transparent" : "#353637";

        Rectangle {
            id: indicator
            anchors.bottom: parent.bottom;
            width: control.focus ? parent.width : 0;
            height: 1.5;
            color: '#2BDFA1';
            Behavior on width{ NumberAnimation {duration: 200;}}
        }
    }
}
