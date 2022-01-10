#include "networkhandler.h"

QDir networkHandler::workDirectory() const
{
    return mWorkDirectory;
}

void networkHandler::setWorkDirectory(const QDir &workDirectory)
{
    QString wd = workDirectory.path();
    if(wd.endsWith("/") == false && wd.endsWith("\\") == false)
        wd += "/";
    if (mWorkDirectory == workDirectory)
        return;

    mWorkDirectory = workDirectory;
    emit workDirectoryChanged(mWorkDirectory);
}
