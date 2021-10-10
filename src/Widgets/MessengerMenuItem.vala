/*
 * Copyright (c) 2021 Manexim (https://github.com/manexim)
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

public class Widgets.MessengerMenuItem : Gtk.Button {
    public string icon { get; construct; }
    public string text { get; construct; }

    public MessengerMenuItem (string icon, string text) {
        Object (
            icon: icon,
            text: text
        );
    }

    class construct {
        set_css_name (Gtk.STYLE_CLASS_MENUITEM);
    }

    construct {
        var label = new Gtk.Label (text) {
            halign = Gtk.Align.START
        };
        label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

        var image = new Gtk.Image.from_gicon (Utilities.load_shared_icon (icon), Gtk.IconSize.DND);

        var grid = new Gtk.Grid () {
            column_spacing = 6
        };
        grid.attach (image, 0, 0, 1, 1);
        grid.attach (label, 1, 0);

        add (grid);
    }
}
