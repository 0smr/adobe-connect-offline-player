#ifndef FILEHANDLER_H
#define FILEHANDLER_H

#include <QXmlStreamReader>
#include <QMetaType>
#include <QFileInfo>
#include <QObject>
#include <QFile>
#include <QUrl>

#include <QDebug>

//#include "session.h"

class fileHandler : public QObject
{
    Q_OBJECT
public:
    explicit fileHandler(QObject *parent = nullptr) : QObject(parent)
    {

    }

    void skipUntil(QXmlStreamReader &xmlReader,QString elementName, QString breakIfElement)
    {
        xmlReader.readNextStartElement();
        while(xmlReader.name() != elementName &&
              xmlReader.name() != breakIfElement &&
              !xmlReader.atEnd())
            xmlReader.readNextStartElement();
    }

    QString getElementValue(QXmlStreamReader &xmlReader,
                               QString elementName,
                               QString breakIfElement = "Message")
    {
        skipUntil(xmlReader,elementName,breakIfElement);
        if(xmlReader.name() == breakIfElement)
            return "";
        xmlReader.readNext();
        return xmlReader.text().toString();
    }

    Q_INVOKABLE QVariantMap extractTimeStamps(QUrl fileAddr)
    {
        QFile indexStream(fileAddr.toLocalFile());
        QVariantMap     tempSession;
        QVariantList    dataStreamList;

        if (!indexStream.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            qDebug()  << "cant open file";
            return QVariantMap();
        }

        QXmlStreamReader xmlReader(&indexStream);

        tempSession["root"] = QFileInfo(indexStream).path();

        while (!xmlReader.atEnd())
        {
            skipUntil(xmlReader,"Message","");

            QString method = getElementValue(xmlReader,"Method");
            QString objectName = getElementValue(xmlReader,"name","String");
            //if Method wasn't playEvent and object name wasn't StreamManagerId_Mainstream skip operation.
            if(method != "playEvent" && objectName != "StreamManagerId_Mainstream")
            {
                xmlReader.readNext();
                // if reach end of indexStream set session duration.
                if(xmlReader.text().toString() == "__stop__")
                {
                    tempSession["duration"] = getElementValue(xmlReader,"Number");
                }

                continue;
            }

            qreal time = getElementValue(xmlReader,"time").toLong();
            QString status = getElementValue(xmlReader,"String");

            if(status == "streamRemoved")
            {
                QVariantMap tds;
                tds["endTimeStamp"]     = time;
                tds["startTimeStamp"]   = getElementValue(xmlReader,"startTime");
                tds["name"]             = getElementValue(xmlReader,"streamName");
                tds["senderId"]         = getElementValue(xmlReader,"streamPublisherID");
                tds["type"]             = getElementValue(xmlReader,"streamType");

                dataStreamList.append(tds);
            }
        }
        tempSession["dataStreamList"] = dataStreamList;
        sessions.append(tempSession);

        return tempSession;
    }

signals:

public slots:

private:
    QVariantList sessions;
};

#endif // FILEHANDLER_H
