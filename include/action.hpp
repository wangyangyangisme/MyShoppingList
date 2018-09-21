#pragma once
#include <QQmlEngine>

class Action : public QObject {
    Q_OBJECT
public:
    enum Type {
        // Views Actions
        VIEW_ACTIONS,
        OpenListManagementWindow,
        OpenListShowerWindow,
        AskForAddList,
        OpenDoShopping,

        OpenIngredientManagementWindow,
        AskForAddGlobalIngredient,

        END_VIEW_ACTIONS
    };

private:
    Q_ENUM(Type)

public:
};

Q_DECLARE_METATYPE(Action::Type)
