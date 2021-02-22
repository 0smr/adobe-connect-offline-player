#ifndef FILEHANDLER_H
#define FILEHANDLER_H

#include <QXmlStreamReader>
#include <QObject>
#include <QFile>
#include <QUrl>

class fileHandler : public QObject
{
    Q_OBJECT
public:
    explicit fileHandler(QObject *parent = nullptr);

    QString getFileContent(QUrl fileAddr)
    {
        QFile file(fileAddr.toLocalFile());
        return file.readAll();
    }

    void extractTimeStamps()
    {

    }

    void getTimeStamps(QUrl fileAddr)
    {
        QString fileContent = getFileContent(fileAddr);


    }

signals:

};

#endif // FILEHANDLER_H
