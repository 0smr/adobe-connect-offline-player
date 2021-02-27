import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

Item {
    id: control

    property real   duration: 0;
    property real   position: 0;
    property alias  playing : audioTimer.running;
    property bool   autoPlay: false;

    property var    audioStreamList: []

    function seek(offset)   {
        position = offset;
        for(var x of audioStreamList)
            x.seekIf();
    }

    function start()        {
        audioTimer.start();
        control.playing = true;
    }

    function stop ()        {
        audioTimer.stop();
        position = 0;
    }

    function pause()        {
        audioTimer.stop();
        control.playing = false;
    }

    function toggle()       {
        control.playing = !control.playing;
    }

    function addAudioStream(url,startTime) {
        var componnent      = Qt.createComponent("AudioStream.qml");
        var streamObject    = componnent.createObject(control);

        streamObject.source         = url;
        streamObject.startTime      = parseInt(startTime);
        streamObject.mainPosition   = Qt.binding(() => {return control.position;});
        streamObject.mainPlay       = Qt.binding(() => {return control.playing;});

        audioStreamList.push(streamObject);
    }

    onPositionChanged: {
        if(position > duration)
            audioTimer.stop();
    }

    Timer {
        id: audioTimer;
        interval: 1;
        repeat: true;
        onTriggered: position++;
        running: control.autoPlay;
    }
}
