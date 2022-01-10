#ifndef FILEHANDLER_H
#define FILEHANDLER_H

#include <QXmlStreamReader>
#include <QCoreApplication>
#include <QDomDocument>
#include <QMetaType>
#include <QFileInfo>
#include <QObject>
#include <QRegExp>
#include <QFile>
#include <QDir>
#include <QUrl>

#include <QDebug>

#include <QtZlib/zlib.h>
#include "3rd Parties/qompress/qzipfile.h"

class fileHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QDir workDirectory READ workDirectory WRITE setWorkDirectory NOTIFY workDirectoryChanged)
public:
    /**
     * @brief fileHandler constructor set work dirctory as './sessions'
     * @param parent
     */
    explicit fileHandler(QObject *parent = nullptr);

    /**
     * @name extractDataStreamTimeStamps
     * @brief extract video and audio time stamps from indexstream.xml file.
     * @param fileAddr
     * @return
     */
    Q_INVOKABLE QVariantMap extractDataStreamTimeStamps(const QUrl & fileAddr);
    /**
     * @brief extractDataStreamExtras
     * @param istreamFilePath
     * @return
     */
    static QVariantList extractDataStreamExtras(const QUrl & istreamFilePath);

    /**
     * @name  firstElementByTagName
     * @brief find first element by given tag name in XML file
     * @param parent
     * @param tagName
     * @return
     */
    static QDomElement firstElementByTagName(const QDomElement & parent,const QString & tagName);
    /**
     * @brief saveFile
     * @param fileName
     * @param downloadedData
     * @param workDirectory
     * @return
     */
    static bool saveFile(QString fileName,const QByteArray &downloadedData,const QDir &workDirectory);
    /**
     * @brief decompressZipFile
     * @param zipFilePath
     * @param baseDirectory
     * @return
     */
    static QString decompressZipFile(const QUrl & zipFilePath, QDir baseDirectory);
    /**
     * @brief workDirectory
     * @return
     */
    QDir workDirectory() const;
signals:
    /**
     * @brief workDirectoryChanged
     * @param workDirectory
     */
    void workDirectoryChanged(QDir workDirectory);
    /**
     * @brief log
     * @param message
     * @param lvl
     */
    void log(QString message,int lvl = 0);

public slots:
    /**
     * @brief isValidDirectory
     * @param folderUrl
     * @return
     */
    bool isValidDirectory(QUrl folderUrl);

    /**
     * @brief isValidUrl
     * @param text
     * @return
     */
    bool isValidUrl(const QString & text)
    {
        QRegExp isUrl(R"~(^.*?\..*\/\w+\/$)~");
        return isUrl.exactMatch(text);
    }

    /**
     * @brief isFile
     * @param urls
     * @return
     */
    QUrl isFile(const QList<QUrl> & urls);
    /**
     * @brief setWorkDirectory
     * @param workDirectory
     */
    void setWorkDirectory(QDir workDirectory);

private:
    QVariantList mSessions;
    QDir mWorkDirectory;
};

#endif // FILEHANDLER_H
