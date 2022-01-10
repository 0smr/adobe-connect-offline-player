import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12

import "../Control"


CustomFrameLessWindow {
    id: window

    minimumWidth: 350;
    minimumHeight: 300;
    visible: true;
    title: qsTr("Offline adobe video player");

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

            Image {
                x: 1
                width: height;
                height: parent.height;
                source: 'qrc:/Resources/Application Icon/ACOP-Grayscale.svg';
            }

            Text {
                leftPadding: parent.height + 2;
                text:       "ACOP";
                font.bold:  true;
                color:      "#eee"
            }

            Row {
                height: parent.height
                anchors.right: parent.right
                //layoutDirection: Qt.RightToLeft

                CustomHeaderButton {
                    text: '\uef3a';
                    font.pixelSize: parent.height * 0.5
                    font.family: icoFont.name;
                    height: parent.height;
                    onPressed: {
                        settigns.visible = true;
                    }
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
                CustomHeaderButton {
                    text: window.stayOnTop ? '\uf031' : '\uf032';
                    font.family: icoFont.name;
                    height: parent.height;
                    onPressed: window.stayOnTop = !window.stayOnTop;
                }
                CustomHeaderButton {
                    text: '\uef9a';
                    font.family: icoFont.name;
                    height: parent.height;
                    onClicked: window.showMinimized();
                }
                CustomHeaderButton {
                    text: window.isMax ? '\uf033' : '\uf034';
                    font.family: icoFont.name;
                    height: parent.height;
                    onClicked: window.toggleMaximized();
                }
                CustomHeaderButton {
                    text: '\ueee4';
                    color: '#C43E5C'
                    font.family: icoFont.name;
                    height: parent.height
                    onClicked: Qt.quit()
                }
            }
        }


    About {
        id: about
    }

    Setting {
        id: settings
    }

}
