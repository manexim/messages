/*
 * Copyright (c) 2020-2021 Manexim (https://github.com/manexim)
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

public class Application : Granite.Application {
    private static Application? _instance;
    private MainWindow window;

    public static Application instance {
        get {
            if (_instance == null) {
                _instance = new Application ();
            }

            return _instance;
        }
    }

    construct {
        var action = new SimpleAction ("show-messenger", VariantType.STRING);
        action.activate.connect ((parameter) => {
            this.hold ();
            string id = parameter.get_string ();
            Services.Messengers.get_default ().visible = id;
            this.release ();
        });

        add_action (action);
    }

    private Application () {
        Object (
            application_id: Config.APP_ID,
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = (
            granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
        );

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = (
                granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
            );
        });

        window = new MainWindow (this);

        window.show_all ();
    }

    public static int main (string[] args) {
        var app = Application.instance;

        return app.run (args);
    }
}
