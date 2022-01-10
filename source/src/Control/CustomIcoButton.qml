import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Button {
    id: control

    property color color: '#eee'

    width: 25;
    height: width;

    background: Item {}

    contentItem: Text {
        id: text;

        text: control.text;
        font: control.font;
        //
        opacity: enabled ? pressed ? 0.7 : 1.0 : 0.3;
        color: control.pressed ? Qt.lighter(control.color) : control.color;
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;

        Behavior on opacity {
            NumberAnimation {duration: 200;}
        }
    }
}
