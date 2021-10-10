/*
 * Copyright (c) 2019-2021 Manexim (https://github.com/manexim)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Authored by: Marius Meisenzahl <mariusmeisenzahl@gmail.com>
 */

public class MainWindow : Hdy.Window {
    private Settings settings;

    construct {
        Hdy.init ();
    }

    public MainWindow (Gtk.Application application) {
        this.application = application;

        settings = Settings.get_default ();
        load_settings ();

        var headerbar = new Hdy.HeaderBar () {
            decoration_layout = "close:",
            show_close_button = true,
            title = Config.APP_NAME
        };

        var main_view = new Views.MainView ();

        var main_layout = new Gtk.Grid ();
        main_layout.attach (headerbar, 0, 0);
        main_layout.attach (main_view, 0, 1);

        add (main_layout);

        delete_event.connect (() => {
            save_settings ();

            return false;
        });
    }

    private void load_settings () {
        if (settings.window_maximized) {
            maximize ();
            set_default_size (settings.window_width, settings.window_height);
        } else {
            set_default_size (settings.window_width, settings.window_height);
        }

        if (settings.window_x < 0 || settings.window_y < 0 ) {
            window_position = Gtk.WindowPosition.CENTER;
        } else {
            move (settings.window_x, settings.window_y);
        }
    }

    private void save_settings () {
        settings.window_maximized = is_maximized;

        if (!settings.window_maximized) {
            int x, y;
            get_position (out x, out y);
            settings.window_x = x;
            settings.window_y = y;

            int width, height;
            get_size (out width, out height);
            settings.window_width = width;
            settings.window_height = height;
        }

        Services.Messengers.get_default ().save ();
    }
}
