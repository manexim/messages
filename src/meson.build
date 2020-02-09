sources = [
    'Config/Constants.vala',
    'Services/Settings.vala',
    'Views/MainView.vala',
    'Widgets/WebView.vala',
    'MainWindow.vala'
]

executable(
    meson.project_name(),
    sources + ['Application.vala'],
    dependencies: [
        gtk_plus_3_dep,
        granite_dep,
        webkit2gtk_4_dep,
    ],
    install: true
)
