import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

Window {
    id: info

    visible: false;
    minimumWidth: 350;
    minimumHeight: 200;

    title: "about"

    flags: Qt.Tool ;

    FontLoader {
        id: consola
        source: 'qrc:/Resources/Fonts/consola.ttf'
    }

    FontLoader {
        id: consolab
        source: 'qrc:/Resources/Fonts/consolab.ttf'
    }

    Image {
        id: name
        x: 10;y: 10;
        width: 50;
        height: width;
        source: "qrc:/Resources/Application Icon/ACOP.svg"
    }

    TextEdit {
        id: aboutText;
        x: 60;
        width:  parent.width - x;
        height: parent.height;
        padding: 10;

        horizontalAlignment: Text.AlignJustify;
        wrapMode: Text.Wrap;

        readOnly: true;
        selectByMouse: true;

        selectionColor: '#009B8A';
        color: '#444';

        font.family: 'Consolas';
        textFormat: Text.RichText;
        text:
            "<b>Adobe Connect Offline Player <small>v 0.1</small></b><br><br>"+
            "Based on Qt 5.15.2<br>"+
            "Copyright 2021 ©SMR, All rights reserved.<br>"+
            "You can check for update in "+
            "<a style='text-decoration:none;color:#6ad' href='https://github.com/SMR76/adobe-connect-offline-player'>Github</a>.<br>"+
            "<b>The program is provided AS IS with NO WARRANTY OF "+
            "ANY KIND, INCLUDING THE WARRANTY OF DESIGN, MERCHANTABILITY "+
            "AND FITNESS FOR A PARTICULAR PURPOSE.</b><br><br>"+
            "Created By <a style='text-decoration:none;color:#6ad' href='https://SMR76.github.io'>SMR</a>.<br>"+
            "<small>feel free to give your suggestions<small>";

        onLinkActivated: {
            Qt.openUrlExternally(link);
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        }
    }
}
