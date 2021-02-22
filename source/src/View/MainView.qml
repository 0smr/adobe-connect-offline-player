import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

import "../Control"

Item {
    id: control
    Column {
        id: colItem
        width: control.width
        height: control.height

        Rectangle {
            width: colItem.width
            height: colItem.height - controlSection.height
            color: 'gray'
            Row {
                anchors.fill: parent

                VideoViewer {
                    id: mediaPlayer
                    width: parent.width
                    height: parent.height
                }
            }
        }

        Rectangle {
            width: colItem.width;
            height: 65;

            border.color: 'black';
            color: '#333';

            Column {
                id: controlSection

                anchors.fill: parent
                topPadding: 10

                Row {
                    width: colItem.width;
                    height: timeLine.height
                    leftPadding: 5
                    rightPadding: 5
                    spacing: 5

                    Text {
                        id: timer
                        width: 75

                        text: '01:01:01/00:00:00'
                        color: '#eee'

                        font.pixelSize: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CustomVideoSlider {
                        id: timeLine

                        width: parent.width - timer.width - 15
                        height: 9;
                        color: mediaPlayer.running ? "#89C4F4" : "#fff"

                        value: mediaPlayer.position / mediaPlayer.duration

                        onValueChanged: {
                            mediaPlayer.seek(mediaPlayer.duration * value)
                        }
                    }
                }

                Row {
                    width:  colItem.width
                    height: controlSection.height - timeLine.height
                }
            }
        }
    }
}
