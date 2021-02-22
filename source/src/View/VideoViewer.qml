import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

import "../Control"

Item {
    id: control

    property alias video: video
    property alias duration: video.duration
    property alias position: video.position
    property alias running : video.running


    function start()        {video.play();      }
    function stop ()        {video.stop();      }
    function seek(offset)   {video.seek(offset);}

    Video {
        id: video
        anchors.fill: parent

        property bool running: false;

        source: "C:/Users/seyye/Desktop/active projects/adobeConnectOfflinePlayer/source/adobe data/screenshare_1_4.flv"
        focus:                  true
        autoPlay:               true
        audioRole:              MediaPlayer.VideoRole

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                if(video.running == false)
                    video.play();
                else
                    video.pause();
            }
        }

        onStopped:  video.running = false;
        onPaused:   video.running = false;
        onPlaying:  video.running = true;

        Keys.onSpacePressed:    video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
        Keys.onLeftPressed:     video.seek(video.position - 5000)
        Keys.onRightPressed:    video.seek(video.position + 5000)
    }
}
