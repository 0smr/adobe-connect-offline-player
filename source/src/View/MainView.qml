import QtQuick 2.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Layouts 1.12 as QQL1
import QtQuick.Window 2.12
import QtMultimedia 5.12

import io.file 1.0

import "../Control"


Item {
    id: control

    signal toggleMaximized();

    function toStandardTime(milisec) {
        let second = milisec / 1000;
        let minute  = second / 60;  second %= 60;
        let hour    = minute / 60;  minute %= 60;

        return Math.floor(hour) + ':' + Math.floor(minute) + ':' + Math.floor(second);
    }

    function mediaPlayerInit(indexStreamFile) {
        videoPlayer.stop();
        audioPlayer.stop();
        timeLine.reset();

        var session = fileHandler.extractDataStreamTimeStamps(indexStreamFile);

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

        audioPlayer.start();
        videoPlayer.start();
    }

    function changeStatus(text) {
        if(videoPlayer.duration !== 0) {
            status.text = text;
            statusTimer.restart();
            status.visible = true;
        }
    }

    FontLoader {
        id: icoFont
        source: "qrc:/Resources/Fonts/icofont.ttf"
    }

    DropArea {
        anchors.fill: parent
        visible: true
        enabled: true

        onDropped: {
            console.log(drop.urls.length)
            var res = "";
            if(drop.hasUrls)
                res = fileHandler.handleUrl(drop.urls);
            else if(drop.hasText)
                res = fileHandler.handleText(drop.text);

            if(res !== "") {
                mediaPlayerInit(res);
                changeStatus("indexstream added");
            }
        }
    }

    Text {
        id: status

        x: 3;
        y: 3;

        text: qsTr("");
        color: '#05E2FF';
        opacity: 0.5;
        visible: false;

        z: 2;

        font {
            family: "Arial";
            bold: true;
            pixelSize: Math.min(control.width, control.height) / 15;
        }

        Timer {
            id: statusTimer;
            onTriggered: status.visible = false;
            interval: 1500;
        }
    }

    Text {
        opacity: 0.7;
        color: 'white';
        text: "Drop Session Here\n+";
        font {
            pixelSize: 17;
            family: "Arial";
        }

        anchors.centerIn: control;
        horizontalAlignment: Text.AlignHCenter;
        z: 2;

        visible: videoPlayer.duration <= 0;
    }

    FileHandler {
        id: fileHandler
    }

    Column {
        id: colItem
        width: control.width
        height: control.height

        Rectangle {
            width: colItem.width
            height: colItem.height - controlSection.height
            color: 'black'
            Row {
                anchors.fill: parent

                VideoPlayer {
                    id: videoPlayer
                    width:  parent.width
                    height: parent.height
                    autoPlay: false;

                    onPositionChanged: {
                        timeLine.value = videoPlayer.position / videoPlayer.duration
                    }

                    MouseArea {
                        anchors.fill: parent;
                        onDoubleClicked: {
                            videoPlayer.toggle();
                            audioPlayer.toggle();
                            if(audioPlayer.playing)
                                changeStatus("play");
                            else
                                changeStatus("puase");
                        }

                        onWheel: {
                            audioPlayer.changeVolume(wheel.angleDelta.y / 1000);
                            changeStatus(Math.floor(audioPlayer.volume * 100));
                        }
                    }
                }

                AudioPlayer {
                    id:audioPlayer

                    autoPlay: false;
                }
            }
        }

        Rectangle {
            id: controlSection
            width: colItem.width;
            height: 65;

            border.color: 'black';
            color: '#333';

            Column {
                height: parent.height;
                width:  parent.width;
                spacing: 2;
                leftPadding: 5;
                topPadding: 5;

                CustomVideoSlider {
                    id: timeLine
                    width: controlSection.width - 10
                    height: 9;
                    color: videoPlayer.playing ? "#89C4F4" : "#777"

                    value: videoPlayer.position / videoPlayer.duration

                    enabled: videoPlayer.duration != 0;

                    onValueChanged: {
                        if(pressed) {
                            videoPlayer.seek((videoPlayer.duration * value).toFixed());
                            audioPlayer.seek((audioPlayer.duration * value).toFixed());
                        }
                    }
                }

                Item {
                    width: timeLine.width
                    height: 10

                    Text {
                        id: timer
                        anchors.fill: parent

                        text: toStandardTime(videoPlayer.position) + '/' +
                              toStandardTime(videoPlayer.duration);

                        color: '#eee'

                        font.pixelSize: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:  childrenRect.width
                    height: controlSection.height - 2 *timeLine.height - 15

                    CustomIcoBottun {
                        id: stop
                        width: parent.height
                        text: '\ueffc'
                        font.family: icoFont.name
                        onClicked: {
                            audioPlayer.stop();
                            videoPlayer.stop();
                            timeLine.reset();
                            changeStatus("stop");
                        }
                    }

                    CustomIcoBottun {
                        id: previes
                        width: parent.height
                        text: '\uec78'
                        font.family: icoFont.name
                        enabled: false;
                    }

                    CustomSwitchToggleButton {
                        id: playPause
                        width: 35;
                        text: '\uec74';
                        secText.text: '\uec72';
                        font.family: icoFont.name;

                        cChecked: videoPlayer.playing

                        onClicked: {
                            audioPlayer.toggle();
                            videoPlayer.toggle();
                        }
                    }

                    CustomIcoBottun {
                        id: next
                        width: parent.height
                        text: '\uec6e'
                        font.family: icoFont.name;
                        enabled: false;
                    }

                    CustomIcoBottun {
                        id: messages
                        width: parent.height
                        text: '\uec68'
                        font.family: icoFont.name;
                        enabled: false;
                    }
                }
            }
        }
    }

    Keys.onPressed: {
        let multi = event.modifiers & Qt.ControlModifier ? 6 : 1;
        if(event.key === Qt.Key_Right) {
            videoPlayer.seek(videoPlayer.position + 5000 * multi);
            audioPlayer.seek(audioPlayer.position + 5000 * multi);
            changeStatus("+" + (5000 * multi / 1000) + " sec");
        } else if(event.key === Qt.Key_Left) {
            videoPlayer.seek(videoPlayer.position - 5000 * multi);
            audioPlayer.seek(audioPlayer.position - 5000 * multi);
            changeStatus("-" + (5000 * multi / 1000) + " sec");
        }

        if(event.key === Qt.Key_Up) {
            audioPlayer.changeVolume(+0.05);
            changeStatus(Math.floor(audioPlayer.volume * 100));
        }
        else if(event.key === Qt.Key_Down) {
            audioPlayer.changeVolume(-0.05);
            changeStatus(Math.floor(audioPlayer.volume * 100));
        }

        if(event.key === Qt.Key_Space) {
            audioPlayer.toggle();
            videoPlayer.toggle();
            if(videoPlayer.playing)
                changeStatus("play");
            else
                changeStatus("pause");
        }

        if(event.key === Qt.Key_Return)
            toggleMaximized();
    }

    focus: true;
}
