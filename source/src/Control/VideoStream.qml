import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

Video {
    id: video
    anchors.fill: parent

    property real startTime     : -1;
    property real mainPosition  : -1;
    property bool mainPlay      : false
    property bool inRange       : mainPosition >= startTime &&
                                  mainPosition < startTime + duration;
    property bool active:       inRange && mainPlay;

    function seekIf() {
        if(inRange)
            video.seek(mainPosition-startTime);
    }

    visible: inRange;

    source: ""
    audioRole:              MediaPlayer.VideoRole

    onActiveChanged: {
        if(active)
            play();
        else
            pause();
    }
}
