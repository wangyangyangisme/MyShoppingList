import QtQuick 2.7
import QtQuick.Controls 2.0
import Action 1.0

import "../categories"
import "../"

Item {
    Item {
        id: root;
        clip: true;
        anchors {
            bottom: footer.top;
            top: parent.top;
            left: parent.left;
            right: parent.right;
        }

        Row {
            Connections {
                target: ListsModel;

                onDataChanged: {
                    var nameIndex = viewName.currentIndex;
                    var categoryIndex = categoryView.currentIndex;

                    viewName.currentIndex = -1;
                    categoryView.currentIndex = -1;

                    viewName.model = undefined;
                    viewName.model = ListsModel;
                    viewName.currentIndex = Math.min(nameIndex, viewName.count - 1);
                    categoryView.currentIndex = Math.min(categoryIndex, categoryView.count - 1);
                }
            }

            anchors.centerIn: parent;
            height: Math.min(parent.height, Math.max(viewName.height, categoryView.height, ingredientView.height));
            spacing: {
                var w = 0;
                for(var i in children)
                    w += children[i].width;
                return (parent.width - w) / children.length;
            }
            ListView {
                id: viewName;
                anchors.verticalCenter: parent.verticalCenter;
                height: Math.min(contentHeight, root.height);
                model: ListsModel;

                delegate: Loader {
                    sourceComponent: Column {
                        Text {
                            id: txt;
                            text: name;

                            MouseArea {
                                anchors.fill: parent;
                                onClicked: viewName.currentIndex = index;
                            }
                        }
                    }

                    onLoaded: {
                        viewName.width = viewName.contentItem.childrenRect.width;
                    }
                }

                highlight: Rectangle {
                    color: "lightgray";
                }

                ScrollBar.vertical: ScrollBar{}
            }

            CategoryShower {
                id: categoryView;
                anchors.verticalCenter: parent.verticalCenter;
                height: Math.min(contentHeight, root.height);
                model: ListsModel.getCategoryIndices(viewName.currentIndex);
            }

            IngredientShower {
                id: ingredientView;
                anchors.verticalCenter: parent.verticalCenter;
                height: Math.min(contentHeight, root.height);
                categoryIndex: categoryView.currentIndex === -1 ? undefined : categoryView.model[categoryView.currentIndex];
                model: ListsModel.getIngredientIndices(viewName.currentIndex, categoryView.currentIndex);
            }
        }
    }

    Button {
        id: footer;
        anchors {
            horizontalCenter: parent.horizontalCenter;
            bottom: parent.bottom;
            bottomMargin: 20;
        }

        text: "Use this list";
        onClicked: ActionCreator.createAction(Action.OpenDoShopping, viewName.currentIndex);
    }
}
