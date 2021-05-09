#include <QCoreApplication>
#include <QObject>
#include <QtNetwork>
#include <QDomDocument>

#include <iostream>
#include <iomanip>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
/*
    QUrl loginURL("https://webinar2.qiet.ac.ir/api/xml?action=login&login=961331014@qiet.ac.ir&password=reza12340");
    QUrl downloadURL("https://webinar2.qiet.ac.ir/prap4nofeeyg/output/outputfile.zip?download=zip");
    QString header = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36";

    QNetworkRequest request(loginURL);
    QNetworkRequest downloadRequest(downloadURL);
    QNetworkAccessManager loginManager;
    QNetworkAccessManager downloadMnager;

    QNetworkCookieJar *jar = new QNetworkCookieJar();

    request.setHeader(QNetworkRequest::UserAgentHeader,header);
    downloadRequest.setHeader(QNetworkRequest::UserAgentHeader,header);

    loginManager.setCookieJar(jar);
    downloadMnager.setCookieJar(jar);

    auto foo1 = [&](QNetworkReply* reply){
        if(reply->error())
            return;

        QDomDocument cookieResponse("response");
        QString content = reply->readAll();
        if (cookieResponse.setContent(content)) {
            QDomNode status = cookieResponse.elementsByTagName("status").at(0);
            QString code = status.toElement().attributeNode("code").value();

            qDebug() << code;
            if(code == "ok") {
                QDomNode token = cookieResponse.elementsByTagName("token").at(0);
                QString cookieValue = token.toElement().text();
                qDebug() << cookieValue;
            }
        }

        auto rep = downloadMnager.get(downloadRequest);
        QObject::connect(rep, &QNetworkReply::downloadProgress,[](qint64 ist, qint64 max){
            std::cout << QString(20,'\b').toStdString();
            std::cout << std::setw(10) << ist
                      << std::setw(10) << max;

        });
        qDebug() << "get";
    };

    auto foo2 = [&](QNetworkReply* reply){
        QSaveFile sf("C:/file.zip");
        sf.open(QSaveFile::WriteOnly);
//        sf.write(reply->readAll());
        sf.commit();
        qDebug() << "response";
    };

    QObject::connect(&downloadMnager, &QNetworkAccessManager::finished,foo2);
    QObject::connect(&loginManager, &QNetworkAccessManager::finished,foo1);

    loginManager.get(request);
*/
    QDir dir("C:/Users/seyye/Desktop/new1/new2/new3");
    dir.mkpath(dir.path());

    return a.exec();
}
