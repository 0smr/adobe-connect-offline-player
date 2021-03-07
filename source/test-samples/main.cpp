#include <QCoreApplication>
#include <QObject>
#include <QtNetwork>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QUrl url("https://webinar2.qiet.ac.ir/system/login-guest?account-id=7&next=%2Fprap4nofeeyg%2Foutput%2Foutputfile.zip%3Fdownload%3Dzip&path"
             "=%2F_a7%2Fprap4nofeeyg%2Foutput%2Foutputfile.zip&set-lang=en&OWASP_CSRFTOKEN=75df226ce15b38b5e37ad1c0e0bb70e94fbfd5d17779c661071319abc2e094e5");
    QNetworkRequest request(url);
    QNetworkAccessManager manager;

    QObject::connect(&manager, &QNetworkAccessManager::finished,[](QNetworkReply* reply){
        if(reply->error())
            return;
        qDebug() << reply->header(QNetworkRequest::ContentTypeHeader).toString();
        qDebug() << reply->header(QNetworkRequest::LastModifiedHeader).toDateTime().toString();;
        qDebug() << reply->header(QNetworkRequest::ContentLengthHeader).toULongLong();
        qDebug() << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        qDebug() << reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
        qDebug() << reply->readAll();

    });

    manager.get(request);



    return a.exec();
}
