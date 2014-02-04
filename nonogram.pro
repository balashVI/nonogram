QT += qml quick

TARGET = nonogram
TEMPLATE = app

SOURCES += \
    main.cpp

RESOURCES += \
    resources.qrc

OTHER_FILES += qml/main.qml \
    qml/InformPanel.qml \
    qml/Button.qml
