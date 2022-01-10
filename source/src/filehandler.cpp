#include "filehandler.h"

fileHandler::fileHandler(QObject *parent) : QObject(parent)
{
    /// set ./sesstions for save extracted files
    setWorkDirectory(QCoreApplication::applicationDirPath() + "/sessions");
}

QVariantMap fileHandler::extractDataStreamTimeStamps(const QUrl &fileAddr)
{
    QFile indexStreamFile(fileAddr.toLocalFile());
    QVariantMap     tempSession;
    QVariantList    dataStreamList;

    if (!indexStreamFile.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qDebug()  << "cant open file";
        return QVariantMap();
    }

    tempSession["root"] = QFileInfo(indexStreamFile).path();

    QDomDocument indexStream("indexStream");

    if (indexStream.setContent(&indexStreamFile))
    {
        QDomNodeList messages = indexStream.elementsByTagName("Message");

        for(int i = 0 ; i < messages.length() ; ++i)
        {
            QDomElement messageEl = messages.at(i).toElement();
            QString name = firstElementByTagName(messageEl,"name").text();
            QString status = firstElementByTagName(messageEl,"String").text();

            if(name == "StreamManagerId_Mainstream" && status == "streamRemoved")
            {
                QVariantMap tds;

                tds["endTimeStamp"]     = firstElementByTagName(messageEl,"time").text();
                tds["startTimeStamp"]   = firstElementByTagName(messageEl,"startTime").text();
                tds["name"]             = firstElementByTagName(messageEl,"streamName").text();
                tds["senderId"]         = firstElementByTagName(messageEl,"streamPublisherID").text();
                tds["type"]             = firstElementByTagName(messageEl,"streamType").text();

                dataStreamList.append(tds);
            }
            else if(status == "__stop__")
            {
                tempSession["duration"]= firstElementByTagName(messageEl,"Number").text();
            }
        }

        tempSession["dataStreamList"] = dataStreamList;
        mSessions.append(tempSession);
    }

    return tempSession;
}

QVariantList fileHandler::extractDataStreamExtras(const QUrl &istreamFilePath)
{
    QFile indexStreamFile(istreamFilePath.toLocalFile());
    QVariantList    extraFileDataList;

    if (!indexStreamFile.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qDebug()  << "cant open file";
        return QVariantList();
    }

    QDomDocument indexStream("indexStream");
    if (indexStream.setContent(&indexStreamFile))
    {
        QDomNodeList messages = indexStream.elementsByTagName("Message");

        for(int i = 0 ; i < messages.length() ; ++i)
        {
            QDomElement messageEl = messages.at(i).toElement();
            QDomNodeList dd = messageEl.elementsByTagName("documentDescriptor");

            // if there is a documentDescriptor in the mesage tag.
            if(dd.isEmpty() == false)
            {
                QDomElement documentDescriptor = dd.at(0).toElement();
                QString docUrl = firstElementByTagName(documentDescriptor,"downloadUrl").text();

                // check if documentDescriptor is empty or not.
                if(docUrl != "")
                {
                    QVariantMap extraFiles;

                    extraFiles["time"]          = firstElementByTagName(messageEl,"time").text();
                    extraFiles["downloadUrl"]   = docUrl;
                    extraFiles["theName"]       = firstElementByTagName(documentDescriptor,"theName").text();
                    QDomElement array           = firstElementByTagName(messageEl,"Array");
                    extraFiles["ctID"]          = firstElementByTagName(array,"ctID").text();

                    extraFileDataList.append(extraFiles);
                }
            }
        }
    }
    return extraFileDataList;
}

QDir fileHandler::workDirectory() const
{
    return mWorkDirectory;
}

QDomElement fileHandler::firstElementByTagName(const QDomElement &parent, const QString &tagName)
{
    if(!parent.elementsByTagName(tagName).isEmpty())
        return parent.elementsByTagName(tagName).at(0).toElement();
    return QDomElement{};
}

bool fileHandler::saveFile(QString fileName, const QByteArray &downloadedData, const QDir &workDirectory)
{
    QFile file(workDirectory.path() + "/" + fileName);

    if(file.open(QFile::WriteOnly))
    {
        file.write(downloadedData);
        file.close();
        return true;
    }
    return false;
}

QString fileHandler::decompressZipFile(const QUrl &zipFilePath, QDir baseDirectory)
{
    qompress::QZipFile zippedFile(zipFilePath.toLocalFile());
    QDir fileDirectory = baseDirectory.path() + "/" + QFileInfo(zipFilePath.toLocalFile()).baseName();

    if (zippedFile.open(qompress::QZipFile::ReadOnly) == false) {
        return "";
    }

    do {
        qompress::QZipFileEntry file = zippedFile.currentEntry();

        if(fileDirectory.exists() == true)
            return "";
        else
            fileDirectory.mkpath(fileDirectory.path());

        QFile unzippedFile( fileDirectory.path() + "/"  + file.name());

        if(unzippedFile.open(QFile::WriteOnly))
        {
            zippedFile.extractCurrentEntry(unzippedFile);
            qDebug() << file.name() << ":\t\t" << file.uncompressedSize() << "bytes (uncompressed)";
            zippedFile.close();
        }
    } while (zippedFile.nextEntry());

    zippedFile.close();
    return fileDirectory.path();
}

bool fileHandler::isValidDirectory(QUrl folderUrl)
{
    return QFile::exists(folderUrl.toLocalFile() + "/indexstream.xml");
}

QUrl fileHandler::isFile(const QList<QUrl> &urls)
{
    if(urls[0].toString().endsWith(".zip"))
    {
        QString iStreamPath = decompressZipFile(urls[0],mWorkDirectory);
        return QUrl::fromLocalFile(iStreamPath + "/indexstream.xml");
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

void fileHandler::setWorkDirectory(QDir workDirectory)
{
    QString wd = workDirectory.path();
    if(wd.endsWith("/") == false && wd.endsWith("\\") == false)
        wd += "/";
    if (mWorkDirectory == workDirectory)
        return;

    mWorkDirectory = workDirectory;
    emit workDirectoryChanged(mWorkDirectory);
}
