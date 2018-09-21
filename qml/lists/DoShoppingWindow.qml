import QtQuick 2.7
import QtQuick.Controls 2.0
import "../categories"

Item {
    id: _r;
    property int listIndex;
    function reset(value) {
        listIndex = value;
    }

    ListView {
        id: categoryView;
        anchors.horizontalCenter: parent.horizontalCenter;

        height: Math.min(parent.height, contentHeight);

        model: ListsModel.getCategoryIndices(listIndex);

        delegate: Loader {
            sourceComponent: Column {
                CategoryDrawer {
                    id: category;
                    obj: CategoryModel.get(modelData);
                }

                IngredientShower {
                    width: category.width;
                    height: contentHeight;
                    categoryIndex: modelData;
                    model: ListsModel.getIngredientIndices(listIndex, index);
                }
            }

            onLoaded: categoryView.width = categoryView.contentItem.childrenRect.width;
        }
        ScrollBar.vertical: ScrollBar{}
    }
}
