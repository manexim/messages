project('com.github.manexim.messages', 'vala', 'c')

i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

gtk_plus_3_dep = dependency('gtk+-3.0')
granite_dep = dependency('granite')
webkit2gtk_4_dep = dependency('webkit2gtk-4.0')

dependencies = [
    gtk_plus_3_dep,
    granite_dep,
    webkit2gtk_4_dep,
]

sources = []

subdir('data')
subdir('plugins')
subdir('po')
subdir('src')

meson.add_install_script('meson/post_install.py')
