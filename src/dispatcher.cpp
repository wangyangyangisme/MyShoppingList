#include "dispatcher.hpp"
#include <QDebug>

Dispatcher::Dispatcher()
{

}

void Dispatcher::dispatch(Action::Type action, QJSValue value) {
    emit dispatched(action, value);
}

bool Dispatcher::inherits(QObject *object, QString className) {
    return object->inherits(className.toStdString().c_str());
}
