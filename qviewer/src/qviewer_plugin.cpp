#include "qviewer_plugin.h"

IVBOOLDOG

#include <qqml.h>
#include <iv_autoloader.h>
#include <iv_log2.h>

#include <iv_version.h>
IVVERSION

ivinternal Log* _log = 0;
ivinternal int pre_dll_init(const param_t* p)
{
//функция инициализации autoloader, stable и т.д
    IVBOOLDOGINIT(p);
    return 0;
}
void QviewerPlugin::registerTypes(const char *uri)
{
    Q_UNUSED(uri);
// т.к вызывается один раз, то решил инициализацию autoloader добавить сюда
    ::iv::autoloader::qml::helper< 10 * 1024 > autoloader(pre_dll_init);
    Q_UNUSED(autoloader);
    _log = ::iv::log::init("qtplugins.iv.viewers.viewer");
}
//реализуем данную функцию для отписки от всех зависимостей(core, log-1 и т.д)
ivexport bool pre_dll_free(const char*)
{
    return true;
}

