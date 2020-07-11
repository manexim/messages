sources += [
    'Config/Constants.vala',
    'Models/Plugin.vala',
    'Services/PluginManager.vala',
    'Services/Settings.vala',
    'Utilities/Icon.vala',
    'Utilities/WebContext.vala',
    'Views/MainView.vala',
    'Widgets/PluginView.vala',
    'MainWindow.vala'
]

executable(
    meson.project_name(),
    sources + ['Application.vala'],
    dependencies: dependencies,
    install: true
)
