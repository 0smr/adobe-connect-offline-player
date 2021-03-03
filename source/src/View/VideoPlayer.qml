import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

Item {
    id: control

    property real   duration: 0;
    property real   position: 0;
    property alias  playing : videoTimer.running;
    property bool   autoPlay: false;

    property var    videoStreamList: []

    function start()        {
        videoTimer.start();
        control.playing = true;
    }

    function seek(offset)   {
        position = offset;
        for(var x of videoStreamList)
            x.seekIf();
    }

    function stop ()        {
        videoTimer.stop();
        position = 0;
    }

    function pause()        {
        videoTimer.stop();
        control.playing = false;
    }

    function toggle()       {
        control.playing = !control.playing;
    }

    function addVideoStream(url,startTime) {
        var componnent = Qt.createComponent("VideoStream.qml");
        var streamObject = componnent.createObject(control);

        streamObject.source         = url;
        streamObject.width          = control.width;
        streamObject.height         = control.height;
        streamObject.startTime      = startTime;
        streamObject.mainPosition   = Qt.binding(() => {return control.position;});
        streamObject.mainPlay       = Qt.binding(() => {return control.playing;});

        videoStreamList.push(streamObject);
    }

    onPositionChanged: {
        if(position > duration)
            videoTimer.stop();
    }

    Timer {
        id: videoTimer
        interval: 1
        repeat: true
        onTriggered: position++;
        running: control.autoPlay
    }
}
