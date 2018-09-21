import QtQuick 2.0
import QtQuick.Controls 2.0
import Action 1.0

ListView{
    id:view;

    delegate: Loader {
        sourceComponent: CategoryDrawer {
            MouseArea {
                anchors.fill: parent;
                onClicked: view.currentIndex = index;
            }

            obj: Tools.isEqual(view.model, CategoryModel) ? model : CategoryModel.get(modelData);
        }

        onLoaded: view.width = view.contentItem.childrenRect.width;
    }

    highlight: Rectangle {
        color: "lightgrey";
    }

    highlightMoveDuration: 0;

    ScrollBar.vertical: ScrollBar{size:0;}
}
