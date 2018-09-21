import QtQuick 2.7
import QtQuick.Controls 2.0

import "../"

ListView {
    property var categoryIndex: -1;
    property bool dragEnabled: false;
    property bool oneItemIsHeld: false;

    id: view;
    width: 100;

    delegate: Loader {
        sourceComponent:  DraggableItem {
            enabled: dragEnabled;
            IngredientDrawer {
                id: e;
                columnWidth: view.width;
                color: held ? "darkgrey" : "transparent";
                obj: Tools.isEqual(view.model, CategoryModel.get(categoryIndex).ingredientList) ? modelData : CategoryModel.getIngredient(categoryIndex, modelData);
            }
            argsToSendToDropArea: ({categoryIndex:categoryIndex, ingredientIndex:index});
            parentDuringDrag: stackView;

            onHeldChanged: view.oneItemIsHeld = held;
        }
        onLoaded: view.width = view.contentItem.childrenRect.width;
    }

    ScrollBar.vertical: ScrollBar{}
}
