QT += qml quick

TARGET = nonogram
TEMPLATE = app

SOURCES += \
    main.cpp

RESOURCES += \
    resources.qrc

OTHER_FILES += qml/main.qml \
    qml/InformPanel.qml \
    qml/Button.qml \
    qml/ListOfCrosswords.qml \
    qml/Scroll.qml \
    qml/Back.qml \
    qml/CrosswordHeader.qml \
    qml/CrosswordBody.qml \
    qml/Slider.qml
