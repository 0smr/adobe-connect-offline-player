import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import Qt.labs.platform 1.1
import Qt.labs.settings 1.0

import "../Control"

Window {
    id: control

    minimumWidth: 350;
    minimumHeight: 260;

    title: "Settings"

    flags: Qt.Tool ;

    property alias folder: settings.folder
    property alias domain: settings.domain

    Settings {
        id: settings
        property string folder: ""
        property string domain: ""

    }

    FontLoader {
        id: icoFont
        source: "qrc:/Resources/Fonts/icofont.ttf"
    }

    FolderDialog {
        id: folderDialog
        folder: "file:///" + (workDirInput.text.length > 0 ? workDirInput.text : applicationDirPath)
        onAccepted: workDirInput.text = (folder+"").slice(8,-1)
    }

    Column {
        id: column
        padding: 15; topPadding: 10;
        width: parent.width - 30;
        height: parent.height - 25;

        Text {
            color: '#aaa';text: 'User Information';
            font.pixelSize: 15;
            font.bold: true;
        }

        Rectangle {height: 1; width: control.width - 30;color: '#999'}
//-------------------------------------------------------------------
        Label {topPadding: 10; text: 'webinar domain:';}
        CustomTextArea {
            id: uacdomain
            width: 310; focus: true;
            placeholderText: 'https://webinar.qiet.ac.ir';
            selectByMouse: true; selectionColor: '#1BB9A1';
        }
        Text {padding:5; font.pixelSize:10; color:'#1BB9A1'; text: '*enter your university adobe connect domain.';}
//-------------------------------------------------------------------
//-------------------------------------------------------------------
        Label {topPadding: 10; text: 'work directory:'}
        Row {
            Item {
                width: 15;height: 15;
                CustomIcoButton {
                    width: parent.width;
                    text: '\uec5b';
                    font.family: icoFont.name;
                    color: '#666'
                    onClicked: folderDialog.open();
                }
            }
            CustomTextArea {
                id: workDirInput;
                width: 295; placeholderText: 'default: applicationDirPath/sessions';
                selectByMouse: true; selectionColor: '#1BB9A1';
                ToolTip.text: text
                ToolTip.visible: text.length > 0 && hovered
                ToolTip.delay: 500

            }
        }

        Text { padding:5; font.pixelSize:10; color:'#1BB9A1'; text: '*all data store here.'; }
//-------------------------------------------------------------------
        Item { width: 50;height: 20; }
    }

    Item {
        width: control.width - 20
        height: control.height - 20
        CustomButton {
            width: 50;height: 20;
            anchors {
                right: parent.right
                bottom: parent.bottom
            }
            text: 'Save'
            onClicked: control.saveData()
        }
    }

    function saveData() {
        settings.domain = uacdomain.text ;
        settings.folder = folderDialog.folder;
        control.close();
    }

    Component.onCompleted: {
        uacdomain.text = settings.domain;
        folderDialog.folder = settings.folder;
    }
}
