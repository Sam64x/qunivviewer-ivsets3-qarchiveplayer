#pragma once
#define BOOMODULE_NOT_USE_RUX
#define BOOLDOG_WHO 80
#define BOO_MODULE_METKA QVIEWER_BEGIN_METKA
#include <booldog/boo_types.h>
#include <iv_booldog.h>
#include <QQmlExtensionPlugin>
class QviewerPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
public:
    void registerTypes(const char *uri);
};
extern boointernal Log* _log;
