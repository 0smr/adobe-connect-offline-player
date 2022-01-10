#include <QCoreApplication>
#include <QObject>
#include <QtNetwork>
#include <QDomDocument>
//#include <QImage>

#include <iostream>
#include <iomanip>

#include <poppler/cpp/poppler-document.h>
#include <poppler/cpp/poppler-page.h>
#include <poppler/cpp/poppler-page-renderer.h>
#include <poppler/cpp/poppler-image.h>

using namespace poppler;

void readPDFtoCV(const std::string& filename,int DPI) {
    document* mypdf = document::load_from_file(filename);
    if(mypdf == NULL) {
        return ;
    }
    std::cout << "pdf has " << mypdf->pages() << " pages\n";
    page* mypage = mypdf->create_page(0);
    page_renderer renderer;
    renderer.set_render_hint(page_renderer::text_antialiasing);
    image myimage = renderer.render_page(mypage,DPI,DPI);
    std::cout << "created image of  " << myimage.width() << "x"<< myimage.height() << "\n";
    myimage.save("C:/Users/seyye/Desktop/file.jpeg","jpeg",DPI);

//    QImage* img = new QImage(640, 480, QImage::Format_RGB16);
//    for (int y = 0; y < img->height(); y++)
//    {
//        memcpy(img->scanLine(y), rawData[y], img->bytesPerLine());
//    }
}
/*
QDomElement firstElementByTagName(const QDomElement &parent, const QString &tagName)
{
    if(!parent.elementsByTagName(tagName).isEmpty())
        return parent.elementsByTagName(tagName).at(0).toElement();
    return QDomElement{};
}
QVariantList extractDataStreamExtras(const QUrl & istreamFilePath)
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
*/
int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    std::cout << "start";
    readPDFtoCV("C:/Users/seyye/Desktop/test.pdf",300);
    std::cout << "done";

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
    QUrl isFile = QUrl::fromLocalFile("C:/Users/seyye/Desktop"
                                      "/active projects/adobe Connect Offline Player"
                                      "/source/adobe data"
                                      "/sample2-LA/indexstream.xml");

    QVariantList qvl ;//= extractDataStreamExtras(isFile);

    qDebug() << QFileInfo(isFile.toLocalFile()).dir().path();

    for(const QVariant &x : qAsConst(qvl))
        std::cout << x.toMap()["ctID"].toString().toStdString() << std::endl;

*/
    return a.exec();
}
