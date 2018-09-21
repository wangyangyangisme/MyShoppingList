QT += qml quick core

CONFIG += c++11 qml_debug

INCLUDEPATH += include

SOURCES += main.cpp \
    src/dispatcher.cpp \
    src/actioncreator.cpp \
    src/list.cpp \
    src/category.cpp \
    src/tools.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

HEADERS += \
    include/dispatcher.hpp \
    include/actioncreator.hpp \
    include/action.hpp \
    include/list.hpp \
    include/category.hpp \
    include/tools.hpp

DISTFILES +=
