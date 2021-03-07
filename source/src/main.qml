import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

import "Control"
import "View"

CustomFrameLessWindow {
    id: window

    minimumWidth: 350;
    minimumHeight: 300;
    visible: true;
    title: qsTr("Offline adobe video player");

    contentItem:
        MainView {
            onToggleMaximized: window.toggleMaximized();
        }
}
