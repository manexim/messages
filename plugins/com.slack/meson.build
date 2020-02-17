name = 'com.slack'

sources += [
    join_paths(meson.source_root(), meson.current_source_dir(), name + '.vala')
]

install_data(
    name + '.svg',
    install_dir: join_paths(get_option('datadir'), meson.project_name(), 'icons')
)
