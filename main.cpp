#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QList>
#include "actioncreator.hpp"
#include "dispatcher.hpp"
#include "category.hpp"
#include "list.hpp"
#include "tools.hpp"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    Dispatcher::getInstance();

    qmlRegisterType<Action>("Action", 1, 0, "Action");
    QQmlApplicationEngine engine;

    CategoryStore model;
    ListStore list;
    Tools tools;

    QObject::connect(&model, &CategoryStore::globalIngredientIsRemoved, &list, &ListStore::globalIngredientIsRemoved);

    engine.rootContext()->setContextProperty("ActionCreator", &ActionCreator::getInstance());
    engine.rootContext()->setContextProperty("AppDispatcher", &Dispatcher::getInstance());
    engine.rootContext()->setContextProperty("CategoryModel", &model);
    engine.rootContext()->setContextProperty("ListsModel", &list);
    engine.rootContext()->setContextProperty("Tools", &tools);
    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));

    return app.exec();
}
