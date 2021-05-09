import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

Item {
    id: control

    property real   duration: 0;
    property real   position: 0;
    property real   volume  : 1;
    property alias  playing : audioTimer.running;
    property bool   autoPlay: false;

    property var    audioStreamList: []

    function seek(offset)   {
        if(offset >= 0 && offset <= duration) {
            position = offset;
            for(var x of audioStreamList)
                x.seekIf();
        }
    }

    function changeVolume(value) {
        value = volume + value  < 0 ? 0 : value;
        value = volume + value  > 1 ? 0 : value;

        control.volume += value;
    }

    function start()        {
        audioTimer.start();
        control.playing = true;
    }

    function stop ()        {
        audioTimer.stop();
        position = 0;
        duration = 0;
        playing = false;

        for(var x of audioStreamList)
            x.destroy();
        audioStreamList = [];
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
        streamObject.volume         = Qt.binding(() => {return control.volume;  });
        streamObject.mainPosition   = Qt.binding(() => {return control.position;});
        streamObject.mainPlay       = Qt.binding(() => {return control.playing; });

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
