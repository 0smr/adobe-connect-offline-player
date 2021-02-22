import QtQuick 2.12
import QtQuick.Controls 1.2 as QQC1
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls.Private 1.0 as QQCP
import QtQuick.Controls.Styles 1.1
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0


QQC2.Control {
    id: control

    property var videoObjects: []
    property var audioObjects: []
    property alias from: rangeModel.minimumValue
    property alias to: rangeModel.maximumValue
    property alias value: rangeModel.value
    property color color: '#89C4F4'
    property color backgroundColor: 'gray'

    property alias pressed: mouseArea.pressed
    //property alias hovered: mouseArea.containsMouse

    height: 15

    background:
        Rectangle {
            color: control.backgroundColor
            border.color: '#eee'
            radius: 2

            clip: true
            Rectangle {
                x: 1
                y: 1
                height: parent.height - 2
                width: rangeModel.position
                color: '#aaa'
            }
        }

    contentItem:
        Column {
            Item {
                id: videoVisulizer

                width: control.width
                height: control.height / 2
                z: 2
            }

            Item {
                id: audioVisulizer

                width: control.width
                height: control.height / 2
            }
        }

//    Rectangle {
//        x: rangeModel.position -1
//        //x: mouseArea.mouseX -1
//        height:
//        width: 0.8
//        color: '#000'

//        Text {
//            x:-width/2+0.4
//            anchors.bottom: parent.top
//            anchors.bottomMargin: -5
//            text: '\uea67'
//            color: '#000'
//        }
//    }

    Rectangle {
        x: rangeModel.position - width/2;
        width: mouseArea.pressed ? 3 : 1;
        height: control.height
        radius: width/2;
        color: '#eee';
        anchors.verticalCenter: control.verticalCenter;

        Behavior on width {
            NumberAnimation {duration: 100;}
        }
    }

    QQCP.RangeModel {
        id: rangeModel
        minimumValue: 0.0;
        maximumValue: 1.0;
        positionAtMinimum: 0;
        positionAtMaximum: control.width;
        stepSize: 0.001;
        value: 0;
    }

    MouseArea {
        id: mouseArea
        anchors.fill: control

        onMouseXChanged: {
            if(mouseArea.pressed) {
                rangeModel.position = mouseX
            }
        }
    }

    property int vidIter: 0;
    property int aduIter: 0;

    function addVideoSubSection(from, to) {
        var component = Qt.createComponent("Section.qml");
        var sec = component.createObject(videoVisulizer);

        sec.from = from;
        sec.to = to;
        sec.x = Qt.binding(() => {return from * control.width});
        sec.width = Qt.binding(() => {return (to - from) * control.width;});
        sec.height = videoVisulizer.height;
        sec.value = Qt.binding(() => {return control.value;});
        sec.color = '#85FFC2';

        videoObjects[vidIter] = sec;
    }

    function addAudioSubSection(from, to) {
        var component = Qt.createComponent("Section.qml");
        var sec = component.createObject(audioVisulizer);

        sec.from = from;
        sec.to = to;
        sec.x = Qt.binding(() => {return from * control.width});
        sec.width = Qt.binding(() => {return (to - from) * control.width;});
        sec.height = audioVisulizer.height;
        sec.value = Qt.binding(() => {return control.value;});
        sec.color = '#FF91FF';

        audioObjects[vidIter] = sec;
    }

    Component.onCompleted:  {
        addVideoSubSection(0.1,0.15)
        addAudioSubSection(0.05,0.4)
        addVideoSubSection(0.6,0.8)
        addAudioSubSection(0.7,0.9)
    }
}
