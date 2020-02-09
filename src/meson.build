sources = [
    'config/Constants.vala',
    'services/Settings.vala',
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

tests = []

foreach test_name : tests
    test_exe = executable(
        '_'.join(test_name.split('/')),
        sources + [test_name + '.test.vala'],
        dependencies: [
            gtk_plus_3_dep,
            json_glib_1_dep,
            posix_dep,
            gee_dep,
            granite_dep,
            soup_dep,
            xml_dep,
            uuid_dep
        ]
    )
    test(
        '_'.join(test_name.split('/')),
        test_exe
    )
endforeach
