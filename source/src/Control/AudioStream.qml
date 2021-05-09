import QtQuick 2.0
import QtMultimedia 5.15

Audio {
    id: audio

    property real startTime     : -1;
    property real mainPosition  : -1;

    property bool mainPlay      : true;
    property bool inRange       : mainPosition >= startTime &&
                                  mainPosition < startTime + duration;
    property bool active        : inRange && mainPlay;

    function seekIf() {
        if(inRange)
            audio.seek(mainPosition-startTime);
    }

    source:     ""
    audioRole:  MediaPlayer.VideoRole

    onActiveChanged: {
        if(active)
            play();
        else
            pause();
    }
}
