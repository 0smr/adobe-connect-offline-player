QT -= gui
QT += network xml

# DEFINES  += QT_NO_SSL

CONFIG += c++11 console
CONFIG -= app_bundle

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

win32 {
    SHARED_LIB_FILES = $$files($$PWD/poppler/lib/*.a)
    message($$SHARED_LIB_FILES)
    for(FILE, SHARED_LIB_FILES) {
        BASENAME = $$basename(FILE)
        LIBS += -l$$replace(BASENAME,\.a,)
    }
}

LIBS += -LC:/msys64/mingw64/bin/*

INCLUDEPATH +=  $$PWD/poppler/include
DEPENDPATH +=   $$PWD/poppler/include

