#include <QDebug>
#include <QDir>
#include <QDataStream>
#include "list.hpp"

ListStore::ListStore(QObject *parent) :
    QAbstractListModel(parent) {
    QFile file(QDir::currentPath() + "/" + "lists.list");

    if(file.exists()) {
        file.open(QIODevice::ReadOnly);
        QDataStream stream(&file);
        stream >> mList;
    }

    else {
        ListElement a, b;
        a.name = "Repas de noel";
        a.categoryIndices << 0 << 2;
        a.ingredientListIndices << (QVariantList() << 0 << 2) << (QVariantList() << 0 << 2);

        b.name = "Repas de pâque";
        b.categoryIndices << 1 << 2;
        b.ingredientListIndices << (QVariantList() << 0 << 2) << (QVariantList() << 0 << 2);
        mList << a << b;
    }
}

int ListStore::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return mList.size();
}

QVariant ListStore::data(const QModelIndex &index, int role) const {
    if(index.row() < 0 && index.row() >= rowCount())
        return QVariant();

    if(role == NameRole)
        return mList[index.row()].name;

    return QVariant();
}

void ListStore::addList(QJSValue _list) {
    ListElement elem;
    QVariantMap list(_list.toVariant().toMap());

    elem.name = list["name"].toString();
    list.remove("name");

    for(auto it = list.begin(); it != list.end(); ++it) {
       elem.categoryIndices << it.key().toInt();
       elem.ingredientListIndices << it->toList();
    }

    if(elem.categoryIndices.isEmpty())
        return;
    mList << elem;
    emit dataChanged(this->index(0), this->index(rowCount() - 1));
}

QVariant ListStore::getCategoryIndices(int index) {
    if(index < 0 || index >= rowCount())
        return QVariant();

    return mList[index].categoryIndices;
}

QVariant ListStore::getIngredientIndices(int index, int categoryIndex) {
    if(index < 0 || index >= rowCount())
        return QVariantList();

    if(categoryIndex < 0 || categoryIndex >= mList[index].categoryIndices.size())
        return QVariantList();

    return mList[index].ingredientListIndices[categoryIndex];
}

void ListStore::globalIngredientIsRemoved(int category, int index) {
    for(ListElement &elem : mList) {
        int indexOfCategory = elem.categoryIndices.indexOf(category);

        if(indexOfCategory == -1)
            continue;

        QVariantList &ingredientList = elem.ingredientListIndices[indexOfCategory];

        for(int i = 0; i < ingredientList.size(); ++i) {
            int current = ingredientList[i].toInt();
            if(current == index) {
                ingredientList.removeAt(i);

                if(ingredientList.empty()) {
                    elem.ingredientListIndices.removeAt(indexOfCategory);
                    elem.categoryIndices.removeAt(indexOfCategory);
                }
                --i;
            }

            else if(current > index) {
                ingredientList[i].setValue(current - 1);
            }
        }
        if(elem.categoryIndices.empty() && elem.ingredientListIndices.empty())
            elem.name = QString();
    }

    mList.removeAll(ListElement());

    emit dataChanged(this->index(0), this->index(this->rowCount() - 1));
}

QHash<int, QByteArray> ListStore::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    return roles;
}

ListStore::~ListStore() {
    QFile file(QDir::currentPath() + "/" + "lists.list");
    file.remove();
    file.open(QIODevice::WriteOnly);
    QDataStream stream(&file);
    stream << mList;
}
