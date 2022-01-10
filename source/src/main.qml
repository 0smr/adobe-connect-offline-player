import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

import "Control"
import "View"

MainWindow {
    id: window

//    contentItem:
//        MainView {
//            onToggleMaximized: window.toggleMaximized();
//        }

    Setting {
        id: settings
        visible: true
    }
}
