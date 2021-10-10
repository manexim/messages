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

public class Dialogs.MessengerAddDialog : Granite.Dialog {
    public Models.Messenger messenger { private get; construct set; }
    private Gtk.Button create_button;

    public MessengerAddDialog (Gtk.Window parent, Models.Messenger messenger) {
        Object (
            transient_for: parent,
            messenger: messenger
        );
    }

    construct {
        var image = new Gtk.Image.from_gicon (Utilities.load_shared_icon (messenger.id), Gtk.IconSize.DND);

        var name_label = new Granite.HeaderLabel (_("Name"));

        var name_entry = new Gtk.Entry () {
            hexpand = true,
            text = messenger.name
        };

        var url_label = new Granite.HeaderLabel (_("URL"));

        var url_entry = new Gtk.Entry () {
            hexpand = true,
            text = messenger.url
        };

        var form_grid = new Gtk.Grid () {
            margin_start = margin_end = 12,
            orientation = Gtk.Orientation.VERTICAL,
            row_spacing = 3,
            valign = Gtk.Align.CENTER,
            vexpand = true
        };
        form_grid.add (image);
        form_grid.add (name_label);
        form_grid.add (name_entry);
        form_grid.add (url_label);
        form_grid.add (url_entry);
        form_grid.show_all ();

        deletable = false;
        modal = true;
        resizable= false;
        width_request = 560;
        window_position = Gtk.WindowPosition.CENTER_ON_PARENT;
        get_content_area ().add (form_grid);

        var cancel_button = add_button (_("Cancel"), Gtk.ResponseType.CANCEL);
        cancel_button.margin_bottom = 6;
        cancel_button.margin_top = 14;

        create_button = (Gtk.Button) add_button (_("Add"), Gtk.ResponseType.OK);
        create_button.margin = 6;
        create_button.margin_start = 0;
        create_button.margin_top = 14;
        create_button.can_default = true;
        create_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        response.connect ((response_id) => {
            if (response_id == Gtk.ResponseType.OK) {
                string name = name_entry.text;
                string url = url_entry.text;

                var new_messenger = new Models.Messenger () {
                    id = messenger.id,
                    name = name,
                    url = url
                };

                Services.Messengers.get_default ().add (new_messenger);
            }

            destroy ();
        });
    }
}
