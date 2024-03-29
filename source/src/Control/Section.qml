import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: control

    property real from  : 0;
    property real to    : 0;
    property real value : 1;
    property bool selected: from <= value && value <= to;
    property alias color: background.color;

    Rectangle {
        id: background;
        opacity: selected ? 1 : 0.8;
        color: '#C8FFD9'

        anchors {
            fill: parent;
        }

        Behavior on opacity {
            NumberAnimation{ duration: 100;}
        }
    }
}
