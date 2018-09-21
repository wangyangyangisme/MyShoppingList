import QtQuick 2.7
import QtQuick.Controls 2.0
import Action 1.0

Item {
    id: root;
    // not really a reset but a refresh
    Image {
        id: dustbin;
        visible: ingredientView.oneItemIsHeld;
        source: "qrc:/Images/bin.png";
        anchors {
            top:parent.top;
            right:parent.right;
        }

        width: 64;
        height: 64;

        sourceSize {
            width: 64;
            height: 64;
        }

        DropArea {
            anchors.fill: parent;
            function process(args) {
                CategoryModel.removeIngredient(args.categoryIndex, args.ingredientIndex);
            }
        }
    }

    Connections {
        target: CategoryModel;

        onDataChanged: {
            var index = categoryView.currentIndex;
            categoryView.currentIndex = -1;
            categoryView.currentIndex = index;
        }
    }

    Row {
        id:row;
        anchors.centerIn: parent;
        height: Math.min(parent.height, Math.max(categoryView.contentHeight, buttonAddIngredient.height, ingredientView.contentHeight));
        spacing: {
            var w = 0;
            for(var i in children)
                w += children[i].width;
            return (parent.width - w) / children.length;
        }

        CategoryShower {
            id: categoryView;
            anchors.verticalCenter: parent.verticalCenter;
            model: CategoryModel;
            height: Math.min(root.height, contentHeight);
        }

        IngredientShower {
            id: ingredientView;
            anchors.verticalCenter: parent.verticalCenter;
            height: Math.min(root.height, contentHeight);
            categoryIndex: categoryView.currentIndex;
            model: CategoryModel.get(categoryIndex).ingredientList;
            dragEnabled: true;
        }

        Item {
            id:buttonAddIngredient;
            anchors.verticalCenter: parent.verticalCenter;
            width: column.width;
            height: column.height;

            Column {
                id:column;

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter;
                    height: 64;
                    width: 64;
                    sourceSize {
                        width: 64; height: 64;
                    }
                    source: "qrc:/Images/add.png";
                }

                Text {
                    id:txt;
                    text: "Add ingredient";
                }
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: ActionCreator.createAction(Action.AskForAddGlobalIngredient, categoryView.currentIndex);
            }
        }
    }
}
