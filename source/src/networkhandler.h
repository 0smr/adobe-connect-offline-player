#ifndef NETWORKHANDLER_H
#define NETWORKHANDLER_H

#include <QObject>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>

class networkHandler : public QObject
{
    Q_OBJECT
public:
    explicit networkHandler(QObject *parent = nullptr) : QObject(parent)
    {
        connect(&mWebControl, &QNetworkAccessManager::finished,
                this, &networkHandler::fileDownloaded);
    }
    virtual ~networkHandler(){}
    QByteArray downloadedData() const
    {
        return mDownloadedData;
    }

signals:
    void downloadFinished();

private slots:
    void fileDownloaded(QNetworkReply* pReply) {
        mDownloadedData = pReply->readAll();
        //emit a signal
        pReply->deleteLater();
        emit downloadFinished();
    }
    void downloadFile(QUrl url)
    {
        QNetworkRequest request(url);
        mWebControl.get(request);
    }
    void saveFile(QUrl destnationUrl,QString fileName)
    {
        QFile file(destnationUrl.toLocalFile() + "/" + fileName);

        if(file.open(QFile::WriteOnly))
        {
            file.write(mDownloadedData);
            file.close();
        }
    }
private:
    QNetworkAccessManager mWebControl;
    QByteArray mDownloadedData;
};
#endif // NETWORKHANDLER_H
