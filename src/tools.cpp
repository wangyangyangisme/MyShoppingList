#include "include/tools.hpp"

bool Tools::isEqual(QJSValue _a, QJSValue _b) {
    QVariant a(_a.toVariant());
    QVariant b(_b.toVariant());
    return a == b;
}
