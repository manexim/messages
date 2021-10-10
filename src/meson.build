sources = [
    'Config/Constants.vala',
    'Dialogs/MessengerAddDialog.vala',
    'Dialogs/MessengerUpdateDialog.vala',
    'Models/Messenger.vala',
    'Services/Messengers.vala',
    'Services/Settings.vala',
    'Utilities/Icon.vala',
    'Views/MainView.vala',
    'Widgets/MessengerMenuItem.vala',
    'Widgets/MessengerView.vala',
    'MainWindow.vala'
]

executable(
    meson.project_name(),
    sources + ['Application.vala'],
    dependencies: [
        granite_dep,
        gtk_plus_3_dep,
        libhandy_dep,
        webkit2gtk_4_dep,
    ],
    install: true
)
