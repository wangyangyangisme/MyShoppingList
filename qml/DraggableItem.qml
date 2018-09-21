import QtQuick 2.0

Item {
    id: root;
    default property var contentItem;
    property var parentDuringDrag;
    property bool held: false;
    property var argsToSendToDropArea : undefined;

    width: contentItem.width;
    height: contentItem.height;

    onContentItemChanged: contentItem.parent = item;

    Item {
        id: item;
        anchors.fill: parent;
        Drag.active: held;

        Drag.hotSpot {
            x: width / 2;
            y: height / 2;
        }

        states: State {
            when: held;

            ParentChange {
                target: item;
                parent: parentDuringDrag;
            }

            PropertyChanges {
                target: item;
                opacity: 0.9;
                anchors.fill: undefined;
                width: contentItem.width;
                height: contentItem.height;
            }

            PropertyChanges {
                target: item.parent;
                height: 0;
            }
        }

        MouseArea {
            id:dragArea;
            drag.target: parent;
            anchors.fill: parent;

            onPressAndHold: held = true;

            onReleased: {
                var area = item.Drag.target;
                held = false;
                if(area)
                    if(area.hasOwnProperty("process"))
                        area.process(argsToSendToDropArea);
            }
        }
    }
}
