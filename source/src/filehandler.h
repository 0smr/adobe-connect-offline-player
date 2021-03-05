#ifndef FILEHANDLER_H
#define FILEHANDLER_H

#include <QXmlStreamReader>
#include <QDesktopServices>
#include <QMetaType>
#include <QFileInfo>
#include <QObject>
#include <QRegExp>
#include <QFile>
#include <QUrl>

#include <QDebug>

#include <zlib.h>

class fileHandler : public QObject
{
    Q_OBJECT
public:
    explicit fileHandler(QObject *parent = nullptr);

    void skipUntil(QXmlStreamReader &xmlReader,QString elementName, QString breakIfElement);
    QString getElementValue(QXmlStreamReader &xmlReader,
                               QString elementName,
                               QString breakIfElement = "Message");
    Q_INVOKABLE QVariantMap extractDataStreamTimeStamps(QUrl fileAddr);

signals:

public slots:
    bool isValidDirectory(QUrl folderUrl);

    QString handleText(QString text)
    {
        QString webUrl = "";

        QRegExp isZipUrl("^https:\\/\\/webinar.*\\.qiet.ac.ir.*download=zip$");
        QRegExp isUrl   ("^(https:\\/\\/|)webinar.*\\.qiet.ac.ir\\/(\\w|\\d)*.$");
        QRegExp isToken ("^(\\w|\\d)*$");

        if(isZipUrl.exactMatch(text))
        {
            webUrl = text   ;
        }
        else if(isUrl.exactMatch(text))
        {
            webUrl = text + (text.endsWith("/") ? "" : "/") + "output/outputfile.zip?download=zips";
        }
        else if(isToken.exactMatch(text))
        {
            //"https://webinar1.qiet.ac.ir/" + text + "/output/outputfile.zip?download=zip";
            webUrl = "https://webinar2.qiet.ac.ir/" + text + "/output/outputfile.zip?download=zip";
        }

        if(webUrl != "")
            QDesktopServices::openUrl(webUrl);

        return "";
    }

    QUrl handleUrl(QList<QUrl> urls)
    {
        if(urls[0].toString().endsWith(".zip"))
        {
            //decompress
            return QUrl("");//urls[0];
        }
        else if(urls[0].toString().endsWith("indexstream.xml"))
        {
            return urls[0];
        }
        else if(isValidDirectory(urls[0]) == true)
        {
            return QUrl(urls[0].toString() + "/indexstream.xml");
        }

        return QUrl("");
    }

    bool decompressZipFile(QUrl workDirectory)
    {
        return false;
    }

private:
    QVariantList sessions;
};

#endif // FILEHANDLER_H
