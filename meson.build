project('com.github.manexim.messages', 'vala', 'c')

gtk_plus_3_dep = dependency('gtk+-3.0')
granite_dep = dependency('granite')
webkit2gtk_4_dep = dependency('webkit2gtk-4.0')

subdir('data')
subdir('src')

meson.add_install_script('meson/post_install.py')
