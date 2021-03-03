#ifndef FILEHANDLER_H
#define FILEHANDLER_H

#include <QXmlStreamReader>
#include <QMetaType>
#include <QFileInfo>
#include <QObject>
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
    bool isValidFolder(QUrl folderUrl);
    bool decompressZipFile(QUrl workDirectory)
    {
        //Open the ZIP archive
        int err = 0;
        zip *z = zip_open("foo.zip", 0, &err);

        //Search for the file of given name
        const char *name = "file.txt";
        struct zip_stat st;
        zip_stat_init(&st);
        zip_stat(z, name, 0, &st);

        //Alloc memory for its uncompressed contents
        char *contents = new char[st.size];

        //Read the compressed file
        zip_file *f = zip_fopen(z, name, 0);
        zip_fread(f, contents, st.size);
        zip_fclose(f);

        //And close the archive
        zip_close(z);

        //Do something with the contents
        //delete allocated memory
        delete[] contents;
        return false;
    }

private:
    QVariantList sessions;
};

#endif // FILEHANDLER_H
