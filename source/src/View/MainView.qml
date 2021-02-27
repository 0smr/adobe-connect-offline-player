import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

import io.file 1.0

import "../Control"


Item {
    id: control

    function toStandardTime(milisec) {
        let second = milisec/1000;
        let minute  = second / 60;  second %= 60;
        let hour    = minute / 60;  minute %= 60;

        return Math.floor(hour) + ':' + Math.floor(minute) + ':' + Math.floor(second);
    }

//    DropArea {
//        anchors.fill: parent
//        visible: true
//        enabled: true

//        onDropped: {
//            if(drop.accepted) {

//            }
//        }
//    }

    FileHandler {
        id: fileHandler

        Component.onCompleted: {
            var session = extractTimeStamps("file:///C:/Users/seyye/Desktop/active projects"+
                                            "/adobeConnectOfflinePlayer/source"+
                                            "/adobe data/indexstream.xml");
            console.log(session.root);

            let rootPath = session.root;

            videoPlayer.duration = session.duration;
            audioPlayer.duration = session.duration;

            for(var x of session.dataStreamList) {

                let url = "file:///" + rootPath + x.name + ".flv";
                let from = x.startTimeStamp / session.duration;
                let to   = x.endTimeStamp   / session.duration;
                let startTime = x.startTimeStamp;

                if(x.type === "screenshare") {
                    videoPlayer.addVideoStream(url, startTime);
                    timeLine.addVideoSubSection(from,to);
                }
                else if(x.type === "cameraVoip") {
                    audioPlayer.addAudioStream(url, startTime);
                    timeLine.addAudioSubSection(from,to);
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: {
            videoPlayer.toggle();
            audioPlayer.toggle();
            console.log("d clicked");
        }
    }

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
                    id: videoPlayer
                    width:  parent.width
                    height: parent.height
                    autoPlay: false;

                    onPositionChanged: {
                        timeLine.value = videoPlayer.position / videoPlayer.duration
                    }
                }

                AudioPlayer {
                    id:audioPlayer

                    autoPlay: false;
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

                        text: toStandardTime(videoPlayer.position) + '/' +
                              toStandardTime(videoPlayer.duration);

                        color: '#eee'

                        font.pixelSize: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CustomVideoSlider {
                        id: timeLine

                        width: parent.width - timer.width - 15
                        height: 9;
                        color: videoPlayer.playing ? "#89C4F4" : "#777"

                        value: videoPlayer.position / videoPlayer.duration

                        onValueChanged: {
                            if(pressed) {
                                videoPlayer.seek((videoPlayer.duration * value).toFixed());
                                audioPlayer.seek((audioPlayer.duration * value).toFixed());
                            }
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
