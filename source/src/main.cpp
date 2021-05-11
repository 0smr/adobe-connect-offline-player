#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QIcon>

#include "filehandler.h"
#include "networkhandler.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<fileHandler>    ("io.file",     1,0,"FileHandler");
    qmlRegisterType<networkHandler> ("io.network",  1,0,"NetworkHandler");

    app.setOrganizationName     ("smr");
    app.setApplicationVersion   ("0.2");
    app.setOrganizationDomain   ("smr67.github.io");
    app.setApplicationName      ("Adobe Connect Offline Player");
    app.setWindowIcon(QIcon(":/Resources/Application Icon/ACOP.ico"));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
    return 0;
}
