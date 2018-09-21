#pragma once
#include <QJSValue>
#include "action.hpp"

class ActionCreator : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void createAction(Action::Type action, QJSValue value);

    static ActionCreator &getInstance() {
        static ActionCreator actionCreator;
        return actionCreator;
    }
};
