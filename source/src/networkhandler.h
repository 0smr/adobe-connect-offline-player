#ifndef NETWORKHANDLER_H
#define NETWORKHANDLER_H

#include <QObject>
#include <QByteArray>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QtNetwork>

#include <QDomDocument>
#include <QFile>
#include <QDir>

#include "filehandler.h"

class networkHandler : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief networkHandler
     * @param parent
     */
    explicit networkHandler(QObject *parent = nullptr) : QObject(parent)
    {
        QNetworkCookieJar *jar = new QNetworkCookieJar();

        /// set mozila header.
        mHeader = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
                         "AppleWebKit/537.36 (KHTML, like Gecko) "
                         "Chrome/89.0.4389.90 Safari/537.36";

        /// add cookie to access manager (cookie is needed to login)
        mAccessManager.setCookieJar(jar);

        /// set ./sesstions for save extracted files (as same as file handler)
        setWorkDirectory(QCoreApplication::applicationDirPath() + "/sessions");
    }
    /**
     * @brief ~networkHandler destructor, it does nothing.
     */
    virtual ~networkHandler(){}
    /**
     * @brief downloadedData
     * @return
     */
    QByteArray downloadedData() const
    {
        return mDownloadedData;
    }
    /**
     * @brief workDirectory
     * @return
     */
    QDir workDirectory() const;
    /**
     * @brief setWorkDirectory
     * @param workDirectory
     */
    void setWorkDirectory(const QDir &workDirectory);

signals:
    /**
     * @brief downloadFinished
     */
    void downloadFinished();
    /**
     * @brief downloadProgress
     * @param value
     * @param max
     */
    void downloadProgress(qint64 value, qint64 max);
    /**
     * @brief downloadFileSize
     * @param size
     */
    void downloadFileSize(qint64 size);
    /**
     * @brief workDirectoryChanged
     * @param workDirectory
     */
    void workDirectoryChanged(QDir workDirectory);
    /**
     * @brief log
     * @param message
     * @param criticalLevel
     */
    void log(QString message, int criticalLevel = 0);

private slots:
    /**
     * @brief login
     * @param username
     * @param password
     * @return
     */
    bool login(QString username, QString password)
    {
        QNetworkRequest loginRequest;
        QString cookieValue;
        QString code;

        loginRequest.setHeader(QNetworkRequest::UserAgentHeader,mHeader);
        loginRequest.setUrl(tr("/api/xml?action=login&login={1}&password={2}").arg(username,password)            );

        QNetworkReply *reply = mAccessManager.get(loginRequest);

        connect(reply, &QNetworkReply::finished, [&](){
            QDomDocument cookieResponse("response");
            QString content = reply->readAll();

            if(reply->error())
                return;

            if (cookieResponse.setContent(content))
            {
                QDomNode status = cookieResponse.elementsByTagName("status").at(0);
                code = status.toElement().attributeNode("code").value();

                if(code == "ok")
                {
                    QDomNode token = cookieResponse.elementsByTagName("token").at(0);
                    cookieValue = token.toElement().text();
                    qDebug() << cookieValue;
                }
            }
        });

        return false;
    }
    /**
     * @brief downloadFile
     * @param url
     */
    void downloadFile(QUrl url)
    {
        QNetworkRequest downloadRequest(url);
        downloadRequest.setHeader(QNetworkRequest::UserAgentHeader,mHeader);
        QNetworkReply *reply = mAccessManager.get(downloadRequest);

        connect(reply, &QNetworkReply::finished, this , &networkHandler::fileDownloaded);
        connect(reply, &QNetworkReply::downloadProgress, [&](qint64 value, qint64 max){
            emit downloadProgress(value,max);
        });
        connect(reply, &QNetworkReply::metaDataChanged, [&](){
            emit downloadFileSize(reply->header(QNetworkRequest::ContentLengthHeader).toInt());
        });
    }

    /**
     * @brief fileDownloaded
     */
    void fileDownloaded()
    {
        QNetworkReply * reply = qobject_cast<QNetworkReply*>(QObject::sender());
        QString url = reply->url().toString();

        QRegularExpression idRegex("\\w*(?=\\/output\\/)");
        QRegularExpression prefixRegex(".*\\/(?=output\\/)");

        QString id = idRegex.match(url).captured();
        QUrl prefixUrl(prefixRegex.match(url).captured());

        mDownloadedData = reply->readAll();

        if(fileHandler::saveFile(id + ".zip",mDownloadedData,mWorkDirectory))
        {
            fileHandler::decompressZipFile(id + ".zip",mWorkDirectory);
            downloadExtraFiles(prefixUrl,mWorkDirectory.path() + tr("/{0}").arg(id));
        }
    }

    bool extraFilesExist(const QUrl & indexStreamPath)
    {
        QVariantList extraFileList = fileHandler::extractDataStreamExtras(indexStreamPath);
        QString iStreamDir = QFileInfo(indexStreamPath.toLocalFile()).dir().path();

        for(QVariant x: extraFileList )
            if(QFile(iStreamDir + x.toMap()["theName"].toString()).exists() == false)
                return false;
        return true;
    }

    /**
     * @brief extraFilesDownloaded
     */
    void extraFilesDownloaded()
    {
        QNetworkReply * reply = qobject_cast<QNetworkReply*>(QObject::sender());
        QString fname = reply->url().fileName();
        if(fileHandler::saveFile(fname,mDownloadedData,mWorkDirectory) == true)
            log(tr("file {0} downloaded.").arg(fname),0);
        else
            log(tr("file {0} downloaded, but can't save it.").arg(fname),0);
    }


    /**
     * @brief downloadExtraFiles
     * @param prefixUrl
     * @param indexStreamPath
     */
    void downloadExtraFiles(const QUrl & prefixUrl,const QUrl & indexStreamPath)
    {
        //source/chap1.2.pdf?download=true
        QVariantList extraFileList = fileHandler::extractDataStreamExtras(indexStreamPath);
        for(auto x : extraFileList)
        {
            QVariantMap extrafilexItem = x.toMap();
            QUrl fileUrl = tr("{0}source/{1}?download=true").arg(prefixUrl.toString(),extrafilexItem["theName"].toString());
            QNetworkRequest extraaFileRequest;
            extraaFileRequest.setUrl(fileUrl);

            QNetworkReply *reply = mAccessManager.get(extraaFileRequest);
            QObject::connect(reply,&QNetworkReply::finished,this,&networkHandler::extraFilesDownloaded);
        }
    }
private:
    QNetworkAccessManager mAccessManager;

    QString mDomain;
    QString mHeader;

    QDir mWorkDirectory;
    QByteArray mDownloadedData;
};
#endif // NETWORKHANDLER_H
