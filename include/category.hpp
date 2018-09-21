#pragma once
#include <QAbstractListModel>
#include <QJSValue>
#include <cassert>
#include <QFileInfo>
#include <QFile>
#include <QDir>
#include <QUrl>
#include <QDataStream>
#include <QDebug>

struct Category {
    Category() = default;
    Category(QString name, QString img, QVariantList ingredientList) :
        name(name), imageURL(img), ingredientList(ingredientList){}

    QString name;
    QString imageURL;
    QVariantList ingredientList;

    operator QVariant() {
        QVariantMap value;
        value["name"] = name;
        value["imageURL"] = imageURL;
        value["ingredientList"] = ingredientList;
        return value;
    }

    bool operator==(Category c) {
        return name == c.name && imageURL == c.imageURL && ingredientList == c.ingredientList;
    }
};

inline QDataStream &operator<<(QDataStream &stream, Category const &category) {
    stream << category.name << category.imageURL << category.ingredientList;
    return stream;
}

inline QDataStream &operator>>(QDataStream &stream, Category &category) {
    stream >> category.name >> category.imageURL >> category.ingredientList;
    return stream;
}

class CategoryStore : public QAbstractListModel {
    Q_OBJECT
public:
    enum CategoryRoles {
        NameRole = Qt::UserRole + 1,
        NumberRole,
        ImageURLRole,
        IngredientListRole
    };

    CategoryStore(QObject *parent = nullptr);
    ~CategoryStore();

public slots:
    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

    Q_INVOKABLE bool isEmpty() const;
    Q_INVOKABLE QVariant get(int index);
    Q_INVOKABLE QVariant getIngredient(int categoryIndex, int ingredientIndex);
    Q_INVOKABLE void removeIngredient(int categoryIndex, int ingredientIndex);
    Q_INVOKABLE void addIngredient(int index, QJSValue value);

protected:
    QHash<int, QByteArray> roleNames() const;

signals:
    void globalIngredientIsRemoved(int categoryIndex, int ingredientIndex);

private:
    QList<Category> mCategories;
};

