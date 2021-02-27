#include <QCoreApplication>
#include "../src/filehandler.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    fileHandler fh;

    fh.ExtractTimeStamps(QUrl::fromLocalFile("C:/Users/seyye/Desktop/active projects"
                                            "/adobeConnectOfflinePlayer/source"
                                            "/adobe data/indexstream.xml"));

    return a.exec();
}
