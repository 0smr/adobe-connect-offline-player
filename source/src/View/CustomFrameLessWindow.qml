import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12

import "../Control"

Window {
    id: window;

    property alias contentItem: page.contentItem;
    property bool isMax: window.visibility === Window.Maximized;
    property bool stayOnTop: false;

    function toggleMaximized() {
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }

    color: 'Transparent'
    flags: Qt.Window |
           Qt.FramelessWindowHint |
           (stayOnTop ? Qt.WindowStaysOnTopHint : 0);

    FontLoader {
        id: icoFont
        source: "qrc:/Resources/Fonts/icofont.ttf"
    }

    MouseArea {
        id: mouseArea

        property real bndry : 4;
        property real edge  : 0;

        function setEdge() {
            var mPos = Qt.point(mouseX,mouseY);
            edge = 0;
            edge |= mPos.x < bndry? Qt.LeftEdge : 0;
            edge |= mPos.y < bndry? Qt.TopEdge  : 0;
            edge |= mPos.x > window.width   - bndry? Qt.RightEdge    : 0;
            edge |= mPos.y > window.height  - bndry? Qt.BottomEdge   : 0;
            return edge;
        }

        anchors.fill: parent;

        hoverEnabled: true;
        propagateComposedEvents: true;
        acceptedButtons: Qt.NoButton;

        cursorShape: {
            if(edge === 1 || edge === 8)    return Qt.SizeVerCursor;
            if(edge === 2 || edge === 4)    return Qt.SizeHorCursor;
            if(edge === 3 || edge === 12)   return Qt.SizeFDiagCursor;
            if(edge === 5 || edge === 10)   return Qt.SizeBDiagCursor;
        }

        onPositionChanged: {
            setEdge();
        }
    }

    DragHandler {
        id: dragHandler

        dragThreshold: 0;
        margin: 20
        onActiveChanged:{
            if(active && mouseArea.containsMouse)
            {
                var edge = mouseArea.setEdge();
                if(edge)
                    window.startSystemResize(edge)
            }
        }
    }

    Page {
        id: page

        x: window.isMax || window.x < 4 ? 0 : 4
        y: window.isMax || window.y < 4 ? 0 : 4


        width:  window.isMax ? parent.width : parent.width - x - 4;
        height: window.isMax ? parent.height: parent.height- y - 4;

        header:
            Rectangle {
                height: 15
                color: 'gray'
                MouseArea {
                    y: 3;
                    height: parent.height;
                    width: parent.width;

                    onPositionChanged:
                        if(containsPress)
                            window.startSystemMove();
                }

                Row {
                    anchors.fill: parent
                    layoutDirection: Qt.RightToLeft

                    CustomHeaderButton {
                        text: '\ueee4';
                        color: '#C43E5C'
                        font.family: icoFont2.name;
                        height: parent.height
                        onClicked: Qt.quit()
                    }
                    CustomHeaderButton {
                        text: window.isMax ? '\uf033' : '\uf034';
                        font.family: icoFont.name;
                        height: parent.height;
                        onClicked: window.toggleMaximized();
                    }
                    CustomHeaderButton {
                        text: '\uef9a';
                        font.family: icoFont.name;
                        height: parent.height;
                        onClicked: window.showMinimized();
                    }
                    CustomHeaderButton {
                        text: window.stayOnTop ? '\uf031' : '\uf032';
                        font.family: icoFont.name;
                        height: parent.height;
                        onPressed: window.stayOnTop = !window.stayOnTop;
                    }
                    CustomHeaderButton {
                        text: '\uef50';
                        font.pixelSize: parent.height * 0.5
                        font.family: icoFont.name;
                        height: parent.height;
                        onPressed: {
                            about.visible = true;
                        }
                    }
                }
            }
    }

    About {
        id: about
    }
}

