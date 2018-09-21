import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import Action 1.0
import "./"

ApplicationWindow {
    id:win;
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    StackView {
        id:stackView;
        property int duration: 100;
        anchors.fill: parent;
        initialItem: Loader {
            sourceComponent: SimpleButtonsColumn {
                model:[{name:"Manage lists", action:Action.OpenListManagementWindow},
                       {name:"Manage Ingredient", action:Action.OpenIngredientManagementWindow}]
            }
        }

        function reset(value) {
            if(currentItem.item.hasOwnProperty("reset"))
                currentItem.item.reset(value);
        }

        function resetPush(args, value) {
            push(args, StackView.Immediate);
            reset(value);
        }

        function resetPop() {
            pop(StackView.Immediate);
            reset();
        }
    }

    Loader {
        active: false;
        id: listManagementWindow;
        source: "SimpleButtonsColumn.qml";
        onLoaded: item.model = [{name:"Create List", action:Action.AskForAddList},
                                {name:"Show lists", action:Action.OpenListShowerWindow}];
    }

    Loader {
        active: false;
        id: listsShowerWindow;
        source: "lists/ListsShower.qml";
    }

    Loader {
        active: false;
        id: ingredientManagementWindow;
        source: "categories/IngredientManagementWindow.qml";
    }

    Loader {
        active: false;
        id: askNewIngredientWindow;
        source: "categories/AskNewIngredientWindow.qml";
    }

    Loader {
        active: false;
        id: askNewListWindow;
        source: "lists/AskNewListWindow.qml";
    }

    Loader {
        active: false;
        id: doShoppingWindow;
        source: "lists/DoShoppingWindow.qml";
    }

    Connections {
        target: AppDispatcher;

        onDispatched: {
            if(action > Action.VIEW_ACTIONS && action < Action.END_VIEW_ACTIONS) {
                var loaders = [listManagementWindow, listsShowerWindow, askNewListWindow, doShoppingWindow,
                               ingredientManagementWindow, askNewIngredientWindow];
                action = action - (Action.VIEW_ACTIONS + 1);
                var loader = loaders[action];
                if(loader.active === false)
                    loader.active = true;

                stackView.resetPush(loader, value);
            }
        }
    }

    onClosing: {
        if(stackView.depth > 1) {
            close.accepted = false;
            stackView.resetPop();
        }
    }
}
