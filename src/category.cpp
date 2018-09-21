#include <QDebug>
#include <QDataStream>
#include "category.hpp"

QVariantMap ingredient(QString name = "", qreal price = 0.f) {
    QVariantMap map;
    map["name"] = name;
    map["price"] = price;
    return map;
}

CategoryStore::CategoryStore(QObject *parent) :
    QAbstractListModel(parent) {
    QFile file(QDir::currentPath() + "/" + "ingredients.list");

    if(file.exists()) {
        file.open(QIODevice::ReadOnly);
        QDataStream stream(&file);
        stream >> mCategories;
    }

    // else we build all the ingredients here
    else {
        QVariantList drinks;
        QVariantList bread;
        QVariantList beauty;
        QVariantList sugarProduct;
        QVariantList saltProduct;
        QVariantList fruit, vegetable;
        QVariantList meat, fish;
        QVariantList freshProduct;

        drinks << ingredient("12 bouteilles d'eau 0.5l", 1.8);
        drinks << ingredient("6 bouteilles d'eau 1.5l", 0.9);
        drinks << ingredient("15 canettes Coca-Cola de 330ml", 6.42);
        drinks << ingredient("Canettes Schweppes agrumes");

        bread << ingredient("Baguette Rustique", 1.0);
        bread << ingredient("Baguette", 0.48);
        bread << ingredient("10 pains au chocolat", 4.9);

        beauty << ingredient("Savon", 3) << ingredient("Shampoing", 3) << ingredient("Dentifrice", 3);
        sugarProduct << ingredient("Gâteaux", 2);
        saltProduct << ingredient("Riz Basmati 1kg", 1.7) << ingredient("Pâtes 1kg", 1);

        fruit << ingredient("Clémentines corse bio 750g", 3.99);
        fruit << ingredient("Citrons jaune 500g", 0.99);

        vegetable << ingredient("Oignons blancs 500g", 2.99);
        vegetable << ingredient("Oignons jaunes 2kg", 1.59);
        vegetable << ingredient("Brocoli au kilo", 1.98);
        vegetable << ingredient("Haricots verts sans fil 1kg", 5.56);

        mCategories << Category("Boissons", "qrc:/Images/drinks.png", drinks);
        mCategories << Category("Boulangerie", "qrc:/Images/breads.png", bread);
        mCategories << Category("Soin", "qrc:/Images/beauty.png", beauty);
        mCategories << Category("Épicerie sucrée", "qrc:/Images/sugarProduct.png", sugarProduct);
        mCategories << Category("Épicerie salée", "qrc:/Images/saltProduct.png", saltProduct);
        mCategories << Category("Fruits", "qrc:/Images/fruits.png", fruit);
        mCategories << Category("Légumes", "qrc:/Images/vegetable.png", vegetable);
        mCategories << Category("Viande", "qrc:/Images/meat.png", meat);
        mCategories << Category("Poissons", "qrc:/Images/fish.png", fish);
        mCategories << Category("Produits frais", "qrc:/Images/freshProduct.png", freshProduct);
    }
}

bool CategoryStore::isEmpty() const {
    return mCategories.empty();
}

int CategoryStore::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return mCategories.size();
}

QVariant CategoryStore::get(int index) {
    if(index < 0 || index >= rowCount())
        return Category();

    return mCategories[index];
}

QVariant CategoryStore::getIngredient(int categoryIndex, int ingredientIndex) {
    if(categoryIndex < 0 || categoryIndex >= rowCount())
        return ingredient();

    if(ingredientIndex < 0 || ingredientIndex >= mCategories[categoryIndex].ingredientList.size())
        return ingredient();

    return mCategories[categoryIndex].ingredientList[ingredientIndex];
}

void CategoryStore::removeIngredient(int categoryIndex, int ingredientIndex) {
    mCategories[categoryIndex].ingredientList.removeAt(ingredientIndex);
    emit globalIngredientIsRemoved(categoryIndex, ingredientIndex);
    emit dataChanged(this->index(categoryIndex), this->index(categoryIndex));
}

void CategoryStore::addIngredient(int index, QJSValue value) {
    if(index < 0 || index >= rowCount())
        return;
    mCategories[index].ingredientList << value.toVariant();
    emit dataChanged(this->index(index), this->index(index));
}

QVariant CategoryStore::data(const QModelIndex &index, int role) const {
    if(index.row() < 0 || index.row() >= rowCount())
        return QVariant();

    if(role == NameRole)
        return mCategories[index.row()].name;

    else if(role == ImageURLRole)
        return mCategories[index.row()].imageURL;

    else if(role == IngredientListRole)
        return mCategories[index.row()].ingredientList;
    return QVariant();
}

QHash<int, QByteArray> CategoryStore::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[NumberRole] = "number";
    roles[ImageURLRole] = "imageURL";
    roles[IngredientListRole] = "ingredientList";
    return roles;
}

CategoryStore::~CategoryStore() {
    QFile file(QDir::currentPath() + "/" + "ingredients.list");
    file.remove();
    file.open(QIODevice::WriteOnly);
    QDataStream stream(&file);
    stream << mCategories;
}
