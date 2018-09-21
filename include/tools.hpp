#pragma once
#include <QObject>
#include <QJSValue>
#include <QDebug>

class Tools : public QObject
{
    Q_OBJECT
public:
    Tools() = default;

    Q_INVOKABLE bool isEqual(QJSValue a, QJSValue b);

private:
};
