sources = [
    'Config/Constants.vala',
    'Models/Messenger.vala',
    'Services/Messengers.vala',
    'Services/Settings.vala',
    'Utilities/Icon.vala',
    'Views/MainView.vala',
    'Widgets/MessengerView.vala',
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
