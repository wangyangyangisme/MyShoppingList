import QtQuick 2.0

Rectangle {
    property real iconWidth : 100;
    property real iconHeight : 75;
    property var obj;
    width: iconWidth + 10;
    height: column.height + 10;
    color: "transparent";

    border {
        color:"black";
        width: 1;
    }

    Column {
        id: column;
        anchors.centerIn: parent;
        Text {
            anchors.horizontalCenter: parent.horizontalCenter;
            text:obj.name;
        }

        Image {
            source: obj.imageURL;
            width: iconWidth;
            height: iconHeight;
            sourceSize {
                width:iconWidth;
                height: iconHeight;
            }
            anchors.horizontalCenter: parent.horizontalCenter;
        }
    }
}
