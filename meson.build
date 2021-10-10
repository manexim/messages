project('com.github.manexim.messages', 'vala', 'c')

i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

granite_dep = dependency('granite')
gtk_plus_3_dep = dependency('gtk+-3.0')
libhandy_dep = dependency('libhandy-1', version: '>=1.0.0')
webkit2gtk_4_dep = dependency('webkit2gtk-4.0')

subdir('data')
subdir('po')
subdir('src')

meson.add_install_script('meson/post_install.py')
