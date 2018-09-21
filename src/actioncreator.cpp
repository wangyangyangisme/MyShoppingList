#include "actioncreator.hpp"
#include "dispatcher.hpp"

void ActionCreator::createAction(Action::Type action, QJSValue value) {
    Dispatcher::getInstance().dispatch(action, value);
}
