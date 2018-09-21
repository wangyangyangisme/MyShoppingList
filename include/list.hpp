#pragma once
#include <QAbstractListModel>
#include <QDataStream>
#include <QJSValue>

struct ListElement {
    QString name;
    QVariantList categoryIndices;

    // list of list
    QList<QVariantList> ingredientListIndices;

    bool operator==(ListElement const &e) {
        return e.name == name && categoryIndices == e.categoryIndices && e.ingredientListIndices == ingredientListIndices;
    }
};

inline QDataStream &operator>>(QDataStream &stream, ListElement &e) {
    stream >> e.name >> e.categoryIndices >> e.ingredientListIndices;
    return stream;
}

inline QDataStream &operator<<(QDataStream &stream, ListElement const &e) {
    stream << e.name << e.categoryIndices << e.ingredientListIndices;
    return stream;
}

class ListStore : public QAbstractListModel {
    Q_OBJECT
    enum ListRoles {
        NameRole = Qt::UserRole + 1,
    };

public:
    ListStore(QObject *parent = nullptr);
    ~ListStore();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;

public slots:
    Q_INVOKABLE void addList(QJSValue list);
    Q_INVOKABLE QVariant getCategoryIndices(int index);
    Q_INVOKABLE QVariant getIngredientIndices(int index, int categoryIndex);

    void globalIngredientIsRemoved(int category, int index);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<ListElement> mList;
};
