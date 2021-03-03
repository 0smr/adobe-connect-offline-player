import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Button {
    id: control

    property alias secText: secText;
    property bool cChecked: false;

    width: 25
    height: width

    //checkable: true;

    background: Item {}

    contentItem: Item {
        Item {
            width: text.width;
            height: text.height;
            clip: true;

            anchors{
                centerIn: parent;
                verticalCenterOffset: -2;
            }

            Text {
                id: text;
                x:  control.cChecked ? -width : 0;
                text: control.text;
                font: control.font;
                opacity: enabled ? pressed ? 0.7 : 1.0 : 0.3;
                color: control.pressed ? "#fff" : "#eee";
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;

                Behavior on x {
                    NumberAnimation{
                        duration: 300;
                        easing.type: Easing.InOutBack;
                    }
                }
            }

            Text {
                id: secText;
                x: text.x + text.width;
                text: control.secText;
                font: text.font;
                opacity: text.opacity;
                color: text.color;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
            }
        }
    }
}
