#include <QtGui/QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl("../nonogram/qml/main.qml"));
    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().value(0));
    window->show();

    return app.exec();
}
