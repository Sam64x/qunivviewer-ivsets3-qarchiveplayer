import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import QtQuick.Window 2.3
import iv.viewers.viewer 1.0
import iv.plugins.loader 1.0

Item {
  id: root




  property int xratio: 4
  property int yratio: 3
  property int id_group: 0
  property string key2: ''
  property bool alert: false
  property bool cyclic: false
  property bool archive: false
  property string qmlRealtime: 'auto'
  property string qmlArchive: 'auto'
  property bool isRealtime: true
  property bool isSetsArchive: false
  property bool isFullscreen: false
  property var globalComponent: null
  property string ivLogin: null
  property string ivPassword: null
  property string ivEventId: null
  property var ivArchiveTime: null
  property string ivArchiveCommand: null
  property string text_primit: null
  property string savedSetName: ''
  property int indexInSavedSet: 0
  property bool running: true
  property bool isCreationInterrupted: false
  property bool isParentCreationInterrupted: false
  property bool fromRealtime:false
  property string quality: ""
  property int myScreenWidth: Screen.width
  property int myScreenHeight: Screen.height
  property bool onceReturn: false
  property alias myCameraObject: viewer_command_obj
  property var myParent: null
  property bool isPTZ: false
  property bool debug_mode: debugVcli !== null && debugVcli !== undefined ? debugVcli.value === "true" ? true : false : false
  property var globSignalsObject: 1
  property int compIndex:-1
  property string unique: "newclient"
  property string wnd_unique: ""
  property bool isArchiveMinViewer: false
  //experimental camera.Layout.preferredHeight  = Qt.binding(function(){return ((mediaViewers.height / mediaViewers.rows)   * camera._rowSpan)   - mediaViewers.rowSpacing;});
//  property int _dx: 1
//  property int _dy: 1
//  //property int _parentCols: 1
//  //property int _parentRows: 1
  property string tab_id: ""
  property var __viewer: null
  property int _row: 0
  property int _col: 0
  property int _rowSpan: 0
  property int _colSpan: 0
  Layout.row: root._row
  Layout.column: root._col
  Layout.rowSpan: root._rowSpan
  Layout.columnSpan: root._colSpan
  Layout.preferredHeight:  ((parent.height / parent.rows)   * root._rowSpan)   -2
  Layout.preferredWidth:   ((parent.width / parent.columns)   * root._colSpan)   -2
  onGlobSignalsObjectChanged:
  {
      console.error("GGGGGGGGGGG onGlobSignalsObjectChanged",root.globSignalsObject)
      if(root.globSignalsObject)
      {
          console.error("GGGGGGGGGGG onGlobSignalsObjectChanged 222222222",root.globSignalsObject)
           mmConn.target = root.globSignalsObject;
      }


  }

  Connections
  {
      //target: root.globSignalsObject
      id:mmConn
      onSetToArchive:
      {
          console.error("GGGGGGGGGGG SET TO ARCH VIEWER" , root.isRealtime)
        if(root.isRealtime)
        {
            root.switch_viewer(null);
        }
      }
      onSetToRealtime:
      {
           console.error("GGGGGGGGGGG SET TO REAL VIEWER" , root.isRealtime)
          if(!root.isRealtime)
          {
              root.switch_viewer(null);
          }
      }
      onTabSelected5:
      {
          root.tab_id = root.globSignalsObject.tabUniqId;
          console.error( "250602 030 tabUniqId ", root.globSignalsObject.tabUniqId );
      }
      onTabUniqIdChanged:
      {
          root.tab_id = root.globSignalsObject.tabUniqId;
          console.error( "250602 031 tabUniqId ", root.globSignalsObject.tabUniqId );
      }
  }

//  function qmltypeof(obj, className) {
//    var str = obj.toString();
//    return str.indexOf(className) !== -1;
//  }
  //QQuickGridLayout QQuickRectangle
 // visible: qmltypeof("Grid")


  //experimental

  IvVcliSetting {
      id: archSwitch
      name: 'sourse_switch_'+root.Window.window.ivComponent.unique
      onValueChanged:
      {
          console.error("AAAAAAAAAA IvVcliSetting archSwitch.value = ",archSwitch.value,root.isRealtime)
//          if(archSwitch.value === "realtime")
//          {
//              if(!root.isRealtime)
//              {
//                  root.switch_viewer(null);
//              }
//          }
//          if(archSwitch.value === "archive")
//          {
//              if(root.isRealtime)
//              {
//                  root.switch_viewer(null);
//              }
//          }
//          if(archSwitch.value === "")
//          {
//          }
//          else
//          {
//              root.switch_viewer(null);
//              //archSwitch.value = "";
//          }
      }
  }
  IvVcliSetting {
      id: archOnly
      name: 'sourse_switch_archive_only_'+root.Window.window.ivComponent.unique
      onValueChanged:
      {
          if(archOnly.value === "true")
          {
              if(root.isRealtime)
              {
                  root.switch_viewer(null);
              }
          }
          if(archOnly.value === "false")
          {
              if(!root.isRealtime)
              {
                  root.switch_viewer(null);
              }
          }
      }
  }
  //Layout.preferredHeight:
  IvVcliSetting {
        id: debugVcli
        name: 'debug.enable'
  }

  IvVcliSetting {
      id: new_arc_strip
      name: 'archive.new_strip'
  }
  IvVcliSetting
  {
      id:camQualitySettings
      name:"quality."+root.key2
  }
    onMyParentChanged:
    {
        //console.error("PARENT = ",root.myParent)

    }
  onGlobalComponentChanged:
  {
      viewer_command_obj.myGlobalComponent = Qt.binding(function(){return root.globalComponent})
  }

  onWidthChanged:
  {
      if(integration_flag.value === "SDK" && root.globalComponent.ivSetsArea === undefined)
      {
        var opac = integration_opac.value;
        if(opac === "" || opac === undefined)
        {
            opac = 1;
            return;
        }
        var doblOpac = parseFloat(opac);
        root.Window.window.opacity = doblOpac;
      }
  }
  Connections{
    target: root.globalComponent
    onSetsSwichSourse:
    {
        console.error("VIEWER SWITCH")
      root.switch_viewer(null);
    }
  }
  QtObject{
        id:viewer_command_obj
        property var myRender: null
        property var myGlobalComponent: null
        signal command_to_viewer(string command)
        onCommand_to_viewer: function (command){
            //root.m_b_ness_pass_params = val;
            //console.info("val = ", m_b_ness_pass_params)
          if (command !== null || command !== undefined)
          {
            switch(command) {
            case 'viewers:switch':
                console.error("VIEWER SWITCH")
              root.switch_viewer(null);
              break;
            case 'viewers:fullscreen':
              root.isFullscreen = !root.isFullscreen;
              //  console.error("IVViewer",command);
              //root.globalComponent.command1('viewers:fullscreen', root,{});
               // root.isFullscreen = !root.isFullscreen;
                if(integration_flag.value === "SDK")
                {
                    root.globalComponent.command1('viewers:fullscreen', root,{});
                }
                else
                {
                    root.globSignalsObject.command1('viewers:fullscreen', root,{})
                }
              break;
            case 'viewers:switchto:archive':
              root.fromRealtime = true;
              root.switch_viewer(false);
              break;
            case 'viewers:switchto:realtime':
              root.fromRealtime = false;
              root.switch_viewer(true);
              break;
            case 'windows:hide':
                console.error("windows:hide = ",command);
             root.globalComponent.command1(command,root,{});

              break;


            case 'sets:area:removecamera2':
              var json = {"key2":root.key2};
              //root.ivComponent.commandToParent(command, json);
              root.globalComponent.setsAreaRemoveCamera2(command, json, root, null)
              break;
            }
          }
        }
        Component.onCompleted: {
          if (root.debug_mode === true)
          {
            IVCompCounter.addComponent(viewer_command_obj);
          }
        }
        Component.onDestruction: {
          if (root.debug_mode === true)
          {
            IVCompCounter.removeComponent(viewer_command_obj);
          }
        }
  }



  IvVcliSetting
  {
    id: integration_flag
    name: 'cmd_args.mode'
  }
  IvVcliSetting
  {
    id: integration_opac
    name: 'sdk.opacity'
    onValueChanged:
    {
        if(integration_flag.value === "SDK" && root.globalComponent.ivSetsArea === undefined)
        {
          var opac = integration_opac.value;
          if(opac === "" || opac === undefined)
          {
              opac = 1;
              return;
          }
          var doblOpac = parseFloat(opac);
          root.Window.window.opacity = doblOpac;
        }
    }
  }
  Timer
  {
      id:propsTimer
      repeat:true
      interval:500
      triggeredOnStart:true
      onTriggered:
      {
          console.error("onQualityChanged = ",root.quality)
          if(rootRect.viewer)
          {
              console.error("onQualityChanged rootRect.viewer = ",root.quality)
              if(root.quality === "Auto")
              {
                  //console.error("onQualityChanged rootRect.viewer auto= ",root.quality)

                  root.safeSetProperty(rootRect.viewer, 'video', Qt.binding(function(){
                    return ( (root.width < (root.myScreenWidth/3)) || (root.height < (root.myScreenHeight/3)) )?'#000_MULTISCREEN':'#000_FULLSCREEN';}));
                    if(integration_flag.value === "SDK")
                   {
                      console.info("IVViewer.qml onQualityChanged camQualitySettings.value = ",camQualitySettings.value)

                      var propSettingsObj = {};
                      if(camQualitySettings.value !== null && camQualitySettings.value !== undefined && camQualitySettings.value !== "")
                      {
                        propSettingsObj = JSON.parse(camQualitySettings.value);

                        propSettingsObj["integration"] = root.quality;
                        var vvv = JSON.stringify(propSettingsObj);
                        if(vvv)
                        {
                           camQualitySettings.value = vvv;
                        }
                      }
                      console.error("onQualityChanged rootRect.viewer = ",camQualitySettings.value)
                   }
              }
              else
              {
                  if(integration_flag.value === "SDK")
                   {
                      try
                      {
                          var propSettingsObj = JSON.parse(camQualitySettings.value);
                          propSettingsObj["integration"] = root.quality;
                          var vvv = JSON.stringify(propSettingsObj);
                          if(vvv)
                          {
                           camQualitySettings.value = vvv;
                          }
                          console.error("onQualityChanged rootRect.viewer = ",camQualitySettings.value)
                      }
                      catch( exception)
                      {
                          console.error("qviewer 123 ",exception );
                           propsTimer.stop();
                      }
                   }
              }
              propsTimer.stop();
          }
      }
  }

onQualityChanged:
{
    propsTimer.start();
}


  onFromRealtimeChanged:
  {

      idLog.debug('<IVViewer.qml>onFromRealtimeChanged, fromRealtime=' + root.fromRealtime);
  }
  function _clear()
  {
     root.xratio = 4;
     root.yratio = 3;
     root.key2 = '';
     root.alert = false;
     root.cyclic = false;
     root.archive = false;
     root.qmlRealtime = 'auto';
     root.qmlArchive = 'auto';
     root.isRealtime = true;
     root.isFullscreen = false;
     root.ivLogin = null;
     root.ivPassword = null;
     root.ivEventId = null;
     root.ivArchiveTime = null;
     root.ivArchiveCommand = null;
     root.text_primit = null;
     root.savedSetName = '';
     root.indexInSavedSet = 0;
     root.running = false;
     root.isCreationInterrupted = true;
     root.isParentCreationInterrupted = true;
  }
  function safeSetProperty(component1, prop, func) {
      //console.info("=========== prop = ", prop, " component = ", component1, " func = ", func);
    if(component1 !== null && component1 !== undefined
            && prop !== null && prop !== undefined
            && func !== null && func !== undefined
            && prop in component1) {
      component1[prop] = func;
    }
  }
  onRunningChanged: {
    idLog.debug('<IVViewer.qml>onRunningChanged, running= ' + root.running + ', ' + key2);
    if(root.running && rootRect.viewer === null) {
       // console.error("state VVVVVVVVVVVVVVVVV 6 onRunningChanged",root.running)
      rootRect.createQml();
    }
  }
  onIsFullscreenChanged: {
    idLog.debug('<IVViewer.qml>onIsFullscreenChanged ' + isFullscreen + ', ' + key2);
  }
  onKey2Changed: {
      //console.error("state VVVVVVVVVVVVVVVVV 3 key2 = ",root.key2)
      root.wnd_unique = root.Window.window.unique
      rootRect.createQml();
      idLog.debug('<IVViewer.qml>onKey2Changed key2 ' + key2);
  }
  onIvArchiveTimeChanged: {
    if(ivArchiveTime !== null && ivArchiveTime.length > 0) {
      isRealtime = false;
    }
    idLog.debug('<IVViewer.qml>onIvArchiveTimeChanged ' + ivArchiveTime + ', ' + key2);
  }
  onText_primitChanged: {
    idLog.debug('<IVViewer.qml>onText_primitChanged ' + text_primit + ', ' + key2);
  }
  onIsRealtimeChanged: {
    idLog.debug('<IVViewer.qml>onIsRealtimeChanged ' + isRealtime + ', ' + key2);
  }

  function switch_viewer(isRealtime) {
    if(isRealtime !== null && root.isRealtime === isRealtime) {
      return;
    }
    if(rootRect.viewer) {
      viewerLoader.destroy1();
    }
    root.fromRealtime = root.isRealtime;
    idLog.debug('<IVViewer.qml>switch_viewer, fromRealtime=' + root.fromRealtime);
    root.isRealtime = !root.isRealtime;
   // console.error("state VVVVVVVVVVVVVVVVV 5 switch_viewer")
    rootRect.createQml();
  }
  Component.onCompleted: {
    if (root.debug_mode === true)
    {
      IVCompCounter.addComponent(root);
    }
    idLog.debug('<IVViewer.qml>Component.onCompleted { ');
    console.info('<IVViewer.qml>Component.onCompleted { ');
//    if('ivType' in root.Window.window && root.Window.window.ivType === 'IVWindowComponent'
//      && root.Window.window.isItWsVideoPlayer(root)) {
//      root.isFullscreen = root.Window.window.visibility === Window.Maximized ? true : false;
//    }
    //console.error("state VVVVVVVVVVVVVVVVV 4 onCompleted")

    var arc_time = "";

    if (root.ivArchiveTime !== null || root.ivArchiveTime !== undefined)
    {
        arc_time = root.ivArchiveTime;
    }

    idLog.debug('<IVViewer.qml>Component.onCompleted unique= '+root.Window.window.unique + ' key2= ' + root.key2 + ' ivArchiveTime= ' + arc_time);
    console.info('<IVViewer.qml>Component.onCompleted unique= ',root.Window.window.unique, ' key2= ', root.key2, ' ivArchiveTime= ', arc_time);

    rootRect.createQml();

    console.info('<IVViewer.qml>Component.onCompleted } ');
    idLog.debug('<IVViewer.qml>Component.onCompleted } ');
  }
  Component.onDestruction: {
    idLog.debug('<IVViewer.qml>Component.onDestruction { ');
    console.info('<IVViewer.qml>Component.onDestruction { ');

      var arc_time = "";

      if (root.ivArchiveTime !== null || root.ivArchiveTime !== undefined)
      {
          arc_time = root.ivArchiveTime;
      }

      idLog.debug('<IVViewer.qml>Component.onDestruction unique= '+root.wnd_unique + ' key2= ' + root.key2 + ' ivArchiveTime= ' + arc_time);
      console.info('<IVViewer.qml>Component.onDestruction unique= ',root.wnd_unique, ' key2= ', root.key2, ' ivArchiveTime= ', arc_time);

    if (root.debug_mode === true)
    {
      IVCompCounter.removeComponent(root);
    }
    viewerLoader.destroy1();
    root._clear();
    //console.error("viewer destroy ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
    console.info('<IVViewer.qml>Component.onDestruction } ');
    idLog.debug('<IVViewer.qml>Component.onDestruction } ');
  }
  Rectangle{
    property var viewer: null
    visible: (root.key2 === '' && !root.alert && !root.cyclic && !root.archive)  ? false : true
    id: rootRect

    anchors.fill: parent
    color: "black"//(rootRect.viewer != null && rootRect.viewer !== undefined)?'black':"transparent"
    function createQml() {

       // console.error("state VVVVVVVVVVVVVVVVV 4 createQml")
      idLog.debug('<IVViewer>createQml {');
      if(root.isCreationInterrupted || root.isParentCreationInterrupted) {
        idLog.debug('<IVViewer>skip createQml');
        idLog.debug('<IVViewer>createQml }');
        return;
      }
      console.error("AAAAAAAAAAAAAAAA archOnly.value = ",archOnly.value , root.isRealtime)
      if(archOnly.value === "true")
      {

          root.isRealtime = false;
      }


     // console.error("state VVVVVVVVVVVVVVVVV 5 createQml")
      if(root.key2 !== '')
      {
        idLog.debug('<IVViewer.qml>createQml, key2=' + root.key2
          + ', visible=' + root.visible);

        var unique = 'qviewer.' + root.Window.window.unique;
        var qmlfile = '/qtplugins/iv/viewers/realtimeplayer/IVRealtimePlayer.qml';
         // console.error("state VVVVVVVVVVVVVVVVV 6 createQml",root.isRealtime);
        if(root.isRealtime){
          idLog.debug('<IVViewer>createQml isRealtime');
          if(root.qmlRealtime !== 'auto')
            qmlfile = root.qmlRealtime;
          root.isArchiveMinViewer = false;
        // console.error("state VVVVVVVVVVVVVVVVV 2")
          viewerLoader.create1(  qmlfile);
        }
        else {
          idLog.debug('<IVViewer>createQml isArchive');

            if ( new_arc_strip.value === "true")
             {
                 qmlfile = '/qtplugins/iv/viewers/archiveplayer/IVArchivePlayerMin.qml';
             }
             else
             {
                 qmlfile = '/qtplugins/iv/viewers/archiveplayer/IVArchivePlayer.qml';
             }

          if(root.qmlArchive !== 'auto')
            qmlfile = root.qmlArchive;
          root.isArchiveMinViewer = qmlfile.indexOf('IVArchivePlayerMin.qml') !== -1;
         // console.error("state VVVVVVVVVVVVVVVVV 3")
          viewerLoader.create1(  qmlfile);
        }
      }
      else if(root.cyclic || root.archive || root.alert)
      {
          idLog.debug('<IVViewer>createQml isAlertViewer');
         // var unique = 'qviewer.' + root.ivComponent.unique;
          qmlfile = '/qtplugins/iv/viewers/IVAlertViewer/IVAlertViewer.qml';
          root.isArchiveMinViewer = false;
          viewerLoader.create1(  qmlfile);
      }
      idLog.debug('<IVViewer>createQml }');
    }
    Loader
    {
        id:viewerLoader
        anchors.fill: parent
        asynchronous: true
        property var componentViewer: null
        property bool isCreated: false
        function create1(qmlFile)
        {
            var qmlFile2 = 'file:///' + applicationDirPath + qmlFile;
            if(viewerLoader.isCreated)
            {
                viewerLoader.destroy1();
            }
           // console.error("CREATE REALTIMEPLAYER")
            viewerLoader.source = qmlFile2;
            viewerLoader.isCreated = true;

        }
        function refresh()
        {
            viewerLoader.destroy1();
            viewerLoader.create();
        }
        function destroy1()
        {
            if(viewerLoader.status !== Loader.Null)
            {
                viewerLoader.item.key2 = "";
                root.isPTZ = false;
                //viewerLoader.item.video = "";
                //viewerLoader.item.savedSetName = "";
                //viewerLoader.item.indexInSavedSet = 0;
                //viewerLoader.item.isFullscreen = false;
                viewerLoader.item.running = false;
                viewerLoader.source = "";
            }
            viewerLoader.isCreated = false;
        }
        onStatusChanged:
        {

            if (viewerLoader.status === Loader.Ready)
            {
                root.safeSetProperty(rootRect.viewer, 'globalSignalsObject', Qt.binding(function() {
                  return root.globSignalsObject;
                }));


                if(root.isCreationInterrupted || root.isParentCreationInterrupted) {
                  // console.error("viewer return")
                  return;
                }
                //key2
                //isPtzEnabled
                rootRect.viewer = viewerLoader.item;
                root.__viewer =viewerLoader.item;
                 //console.error("viewer =",rootRect.viewer);
                //rootRect.viewer.anchors.fill = Qt.binding(function(){ return rootRect;});
                root.safeSetProperty(rootRect.viewer, 'arc_vers',1);
                console.error("qviewer key2 = ",root.key2);
                if (root.isArchiveMinViewer) {
                  root.safeSetProperty(rootRect.viewer, 'key2',
                    Qt.binding(function(){ return root.key2}));
                  root.safeSetProperty(rootRect.viewer, 'video', Qt.binding(function(){
                      return !root.isFullscreen ?'#000_MULTISCREEN':'#000_FULLSCREEN';}));
                  root.safeSetProperty(rootRect.viewer, 'isFullscreen', Qt.binding(function(){
                    return root.isFullscreen;
                  }));
                  if ( rootRect.viewer.tab_id !== undefined )
                    rootRect.viewer.tab_id = root.tab_id;
                  idLog.debug('<IVViewer.qml>onBindings, fromRealtime=' + root.fromRealtime);
                  root.safeSetProperty(rootRect.viewer, 'fromRealtime',Qt.binding(function(){ return root.fromRealtime}));
                  root.safeSetProperty(rootRect.viewer, 'isRealtime', Qt.binding(function(){
                    return root.isRealtime;
                    }));
                  if(root.ivArchiveTime !== null) {
                    idLog.error('<IVViewer.qml>' + ' onBindings root.key2 ' + root.key2 +
                      ' root.ivArchiveTime ' + root.ivArchiveTime);
                    root.safeSetProperty(rootRect.viewer, 'time', Qt.binding(function(){
                      return root.ivArchiveTime;
                      }));
                  }
                  if(root.ivArchiveCommand !== null) {
                    root.safeSetProperty(rootRect.viewer, 'cmd', Qt.binding(function(){
                      return root.ivArchiveCommand;
                      }));
                  }
                  root.safeSetProperty(rootRect.viewer, 'running', Qt.binding(function(){
                    return root.running;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'viewer_command_obj', Qt.binding(function() {
                    return viewer_command_obj;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'globalComponent', Qt.binding(function() {
                    return root.globalComponent;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'globSignalsObject', Qt.binding(function() {
                    return root.globSignalsObject;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'globalSignalsObject', Qt.binding(function() {
                    return root.globSignalsObject;
                  }));
                } else {
                  //rootRect.viewer.key2 = root.key2;
                  root.safeSetProperty(rootRect.viewer, 'key2',
                    Qt.binding(function(){ return root.key2}));
                  root.isPTZ = Qt.binding(function (){return rootRect.viewer.isPtzEnabled});
                  root.safeSetProperty(rootRect.viewer, 'video', Qt.binding(function(){
                      return !root.isFullscreen ?'#000_MULTISCREEN':'#000_FULLSCREEN';}));
                  root.safeSetProperty(rootRect.viewer, 'compIndex', Qt.binding(function(){
                      return root.compIndex}));
                  root.safeSetProperty(rootRect.viewer, 'savedSetName', Qt.binding(function(){
                    return root.savedSetName;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'guid', Qt.binding(function(){
                    return root.guid;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'indexInSavedSet', Qt.binding(function(){
                    return root.indexInSavedSet;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'isFullscreen', Qt.binding(function(){
                    return root.isFullscreen;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'alert', Qt.binding(function(){
                    return root.alert;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'cyclic', Qt.binding(function(){
                    return root.cyclic;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'archive', Qt.binding(function(){
                    return root.archive;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'isSetsArchive', Qt.binding(function(){
                    return root.isSetsArchive;
                  }));
                  if ( rootRect.viewer.tab_id !== undefined )
                    rootRect.viewer.tab_id = root.tab_id;
                  idLog.debug('<IVViewer.qml>onBindings, fromRealtime=' + root.fromRealtime);
                  root.safeSetProperty(rootRect.viewer, 'fromRealtime',Qt.binding(function(){ return root.fromRealtime}));
                  root.safeSetProperty(rootRect.viewer, 'isRealtime', Qt.binding(function(){
                    return root.isRealtime;
                    }));
                  if(root.isRealtime === false) {
                    if(root.ivArchiveTime !== null) {
                      idLog.error('<IVViewer.qml>' + ' onBindings root.key2 ' + root.key2 +
                        ' root.ivArchiveTime ' + root.ivArchiveTime);
                      root.safeSetProperty(rootRect.viewer, 'time', Qt.binding(function(){
                        return root.ivArchiveTime;
                        }));
                    }
                    if(root.ivArchiveCommand !== null) {
                      root.safeSetProperty(rootRect.viewer, 'cmd', Qt.binding(function(){
                        return root.ivArchiveCommand;
                        }));
                    }
                  }
                  if (root.text_primit !== null)
                  {
                    root.safeSetProperty(rootRect.viewer, 'text_primit', Qt.binding(function(){
                    return root.text_primit;
                  }));
                  }
                  if(root.ivLogin !== null) {
                    root.safeSetProperty(rootRect.viewer, 'login', root.ivLogin);
                  }
                  if(root.ivPassword !== null) {
                    root.safeSetProperty(rootRect.viewer, 'password', root.ivPassword);
                  }
                  root.safeSetProperty(rootRect.viewer, 'running', Qt.binding(function(){
                    return root.running;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'isParentCreationInterrupted', Qt.binding(function() {
                    return root.isCreationInterrupted;
                  }));

                  root.safeSetProperty(rootRect.viewer, 'viewer_command_obj', Qt.binding(function() {
                    return viewer_command_obj;
                  }));

                  root.safeSetProperty(rootRect.viewer, 'globalComponent', Qt.binding(function() {
                    return root.globalComponent;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'globSignalsObject', Qt.binding(function() {
                    return root.globSignalsObject;
                  }));
                  root.safeSetProperty(rootRect.viewer, 'globalSignalsObject', Qt.binding(function() {
                    return root.globSignalsObject;
                  }));
                }

                idLog.error('<IVViewer.qml> 250530 021 ' );
                if(root.isRealtime === false) {
                  idLog.error('<IVViewer.qml> 250530 022 ' );
                  if (rootRect.viewer.startPlugin !== undefined && typeof rootRect.viewer.startPlugin === "function")
                  {
                     idLog.error('<IVViewer.qml> 250530 001 tab_id ' + root.tab_id );
                     rootRect.viewer.startPlugin();
                  }
                }
                propsTimer.start();

            }
            if(viewerLoader.status === Loader.Error)
            {
                console.error("viewer loader error");
            }
            if(viewerLoader.status === Loader.Null)
            {

            }
        }
    }
  }
  Connections{
    target: root.Window.window
    onVisibilityChanged: {
//      idLog.info('<IVViewer.qml> Connections onVisibilityChanged {');
//      idLog.info('<IVViewer.qml> Connections key2 ' + root.key2);
//      if('ivType' in root.Window.window && root.Window.window.ivType == 'IVWindowComponent'
//        && root.Window.window.isItWsVideoPlayer(root)) {
//        root.isFullscreen = root.Window.window.visibility == Window.Maximized ? true : false;
//        idLog.info('<IVViewer.qml> Connections onVisibilityChanged root.isFullscreen '+root.isFullscreen);
//      }
//      idLog.info('<IVViewer.qml> Connections onVisibilityChanged }');
    }
    onKey2Changed: {
      idLog.info('<IVViewer.qml> Connections onKey2Changed {');
      idLog.info('<IVViewer.qml> Connections key2 ' + root.key2);
     // if('ivType' in root.Window.window && root.Window.window.ivType == 'IVWindowComponent'
      //  && root.Window.window.isItWsVideoPlayer(root)) {
        root.key2 = root.Window.window.key2;
        idLog.info('<IVViewer.qml> Connections onKey2Changed root.key2 '+root.key2);
      //}
      idLog.info('<IVViewer.qml> Connections onKey2Changed }');
    }
    onIvArchiveTimeChanged: {
      idLog.info('<IVViewer.qml> Connections onIvArchiveTimeChanged {');
      idLog.info('<IVViewer.qml> Connections key2 ' + root.key2);
      //if('ivType' in root.Window.window && root.Window.window.ivType === 'IVWindowComponent'
       // && root.Window.window.isItWsVideoPlayer(root)) {
        root.ivArchiveTime = root.Window.window.ivArchiveTime;
        idLog.info('<IVViewer.qml> Connections onIvArchiveTimeChanged root.ivArchiveTime + '+root.ivArchiveTime);
      //}
      idLog.info('<IVViewer.qml> Connections onIvArchiveTimeChanged }');
    }
    onIsRealtimeChanged: {
      idLog.info('<IVViewer.qml> Connections onIsRealtimeChanged {');
      idLog.info('<IVViewer.qml> Connections key2 ' + root.key2);
      //if('ivType' in root.Window.window && root.Window.window.ivType == 'IVWindowComponent'
      //  && root.Window.window.isItWsVideoPlayer(root)) {
        root.isRealtime = root.Window.window.isRealtime;
        idLog.info('<IVViewer.qml> Connections onIsRealtimeChanged root.isRealtime '+root.isRealtime);
    //  }
      idLog.info('<IVViewer.qml> Connections onIsRealtimeChanged }');
    }
    onText_primitChanged: {
      idLog.info('<IVViewer.qml> Connections onText_primitChanged {');
      idLog.info('<IVViewer.qml> Connections key2 ' + root.key2);
      //if('ivType' in root.Window.window && root.Window.window.ivType == 'IVWindowComponent'
      //  && root.Window.window.isItWsVideoPlayer(root)) {
        root.text_primit = root.Window.window.text_primit;
        idLog.info('<IVViewer.qml> Connections onText_primitChanged root.text_primit '+root.text_primit);
     // }
      idLog.info('<IVViewer.qml> Connections onText_primitChanged }');
    }
    onVisibleChanged:
    {
//        idLog.info('<IVViewer.qml> Connections onVisibleChanged {');
//        idLog.info('<IVViewer.qml> Connections key2 ' + root.key2);
//          if('ivType' in root.Window.window && root.Window.window.ivType == 'IVWindowComponent'
//            && root.Window.window.isItWsVideoPlayer(root))
//          {
//              idLog.info('<IVViewer.qml> Connections onVisibleChanged 1');
//            if(!root.Window.window.visible)
//            {
//                idLog.info('<IVViewer.qml> Connections onVisibleChanged 2');
//                viewerLoader.destroy1();
//                rootRect.viewer = null;
//                root.isRealtime = true;
//                root.ivArchiveTime = null;
//                //_clear();
//                idLog.info('<IVViewer.qml> Connections onVisibleChanged 3');
//            }
//            else
//            {
//              idLog.info('<IVViewer.qml> Connections onVisibleChanged 4');
//              rootRect.createQml();
//              idLog.info('<IVViewer.qml> Connections onVisibleChanged 5');
//            }
//          }
//          idLog.info('<IVViewer.qml> Connections onVisibleChanged }');
        }
  }
  Iv7Log {
    id: idLog
    name: 'qtplugins.iv.viewers.viewer'
  }
}
