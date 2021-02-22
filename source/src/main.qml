import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

import "Control"
import "View"

Window {
    id: window
    minimumWidth: 350
    minimumHeight: 300
    visible: true
    title: qsTr("Offline adobe video player")

    MainView {
        id: vv

        anchors.fill: parent
    }
}
