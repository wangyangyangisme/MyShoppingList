import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle {
    property alias columnWidth : column.width;
    property var obj;
    id: item;

    width: columnWidth;
    height: column.height + 10;

    border {
        color:"black";
        width: 1;
    }

    Column {
        id: column;
        anchors.centerIn: parent;

        Text {
            anchors.horizontalCenter: parent.horizontalCenter;
            width: parent.width;
            horizontalAlignment: Text.AlignHCenter;
            text: obj.name;
            wrapMode: Text.Wrap;
        }

        Rectangle {
            width: parent.width;
            height: 1;
            color: "blue";
        }

        Text {
            horizontalAlignment: Text.AlignHCenter;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: obj.price + "€";
            width: parent.width;
        }
    }
}
