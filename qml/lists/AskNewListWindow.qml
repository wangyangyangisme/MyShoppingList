import QtQuick 2.7
import QtQuick.Controls 2.0

import "../categories"

Item {
    function reset() {
        name.text = "";
        column.shoppingList = {};
        categoryToAddView.model = undefined;
    }

    function getModel() {
        var list = column.shoppingList;
        var model = [];

        for(var p in list) {
            var category = {categoryIndex: p, ingredients:[]};
            var ingredients = list[p];
            for(var i in ingredients)
                category.ingredients.push(ingredients[i]);
            model.push(category);
        }
        return model;
    }

    Item {
        id: header;
        height: childrenRect.height;
        width: childrenRect.width;
        anchors {
            horizontalCenter: parent.horizontalCenter;
            top: parent.top;
            topMargin: 20;
        }

        TextField {
            id:name;
            placeholderText: "Enter the name of the list";
        }

        Button {
            id:createButton;
            anchors.leftMargin: 20;
            anchors.left: name.right
            text: "Create the list";
            onClicked: {
                var list = column.shoppingList;
                list.name = name.text;
                ListsModel.addList(list);
                stackView.resetPop();
            }
        }
    }

    Item {
        id: root;
        anchors {
            top: header.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        Row {
            anchors.centerIn: parent;
            height: Math.min(parent.height, Math.max(categoryView.height, ingredientView.height));

            spacing: {
                var w = 0;
                for(var i in children)
                    w += children[i].width;
                return (parent.width - w) / children.length;
            }

            CategoryShower {
                id: categoryView;
                anchors.verticalCenter: parent.verticalCenter;
                height: Math.min(root.height, contentHeight);
                model: CategoryModel;
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
                id: c;
                anchors.verticalCenter: parent.verticalCenter;
                width: column.width;
                height: column.height;

                Column {
                    property var shoppingList;
                    id: column;
                    anchors.verticalCenter: parent.verticalCenter;
                    Rectangle {
                        id: headerList;
                        border.width: 1;
                        width: categoryView.width;
                        height: txt.height * 2;
                        border.color: "black";

                        Text {
                            id: txt;
                            anchors.centerIn: parent;
                            width: implicitWidth;
                            height: implicitHeight;
                            text: "Drag Ingredient\n         here";
                        }

                    }

                    ListView {
                        id: categoryToAddView;
                        clip: true;

                        height: Math.min(contentHeight, root.height - headerList.height);
                        width: column.width;

                        delegate: ListView {
                            property int categoryIndex: modelData.categoryIndex;
                            id: ingredientToAddView;
                            height: contentHeight;
                            width: column.width;
                            model: modelData.ingredients;

                            delegate: IngredientDrawer {
                                columnWidth: column.width;
                                color: "transparent";
                                obj: CategoryModel.getIngredient(categoryIndex, modelData);
                            }
                        }
                        ScrollBar.vertical: ScrollBar {}
                    }
                }

                DropArea {
                    anchors.fill: parent;
                    function process(args) {
                        var list = column.shoppingList;
                        if(!list.hasOwnProperty(args.categoryIndex))
                            list[args.categoryIndex] = [];
                        if(list[args.categoryIndex].indexOf(args.ingredientIndex) !== -1)
                            return;
                        list[args.categoryIndex].push(args.ingredientIndex);
                        categoryToAddView.model = getModel();
                    }
                }
            }
        }
    }
}
