#pragma once
#include <QJSValue>
#include "action.hpp"

class Dispatcher : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void dispatch(Action::Type action, QJSValue value);

    Q_INVOKABLE bool inherits(QObject *object, QString className);

signals:
    void dispatched(Action::Type action, QJSValue value);

public:
    static Dispatcher &getInstance() {
        static Dispatcher dispatcher;
        return dispatcher;
    }

private:
    Dispatcher();
};
