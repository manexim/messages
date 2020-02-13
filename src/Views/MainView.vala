/*
* Copyright (c) 2020 Manexim (https://github.com/manexim)
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

public class Views.MainView : Gtk.Paned {
    construct {
        orientation = Gtk.Orientation.HORIZONTAL;

        var grid = new Gtk.Grid ();
        var stack = new Gtk.Stack ();

        grid.orientation = Gtk.Orientation.VERTICAL;
        var list_box = new Gtk.ListBox ();
        list_box.selection_mode = Gtk.SelectionMode.SINGLE;
        list_box.activate_on_single_click = true;

        var messengers = Services.Messengers.get_default ().data;
        for (var i = 0; i < messengers.length; i++) {
            var messenger = messengers[i];

            var view = new Widgets.MessengerView (messenger);
            stack.add_named (view, "%d".printf (i));

            var menu_item = new Gtk.MenuItem ();

            var image = new Gtk.Image.from_gicon (Utilities.load_shared_icon (messenger.id), Gtk.IconSize.DND);
            var label = new Gtk.Label (messenger.name);
            var unread_notifications = new Gtk.Label (
                (messenger.unread_notifications > 0) ? "%u".printf (messenger.unread_notifications) : ""
            );

            messenger.notify.connect (() => {
                debug ("[%s] unread_notifications: %u", messenger.id, messenger.unread_notifications);

                if (stack.get_visible_child () != view) {
                    unread_notifications.label =
                        (messenger.unread_notifications > 0) ? "%u".printf (messenger.unread_notifications) : "";
                } else if (messenger.unread_notifications == 0) {
                    unread_notifications.label = "";
                }
            });

            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            box.pack_start (image, false, false, 0);
            box.pack_start (label, false, false, 0);
            box.pack_end (unread_notifications, false, false, 0);

            menu_item.add (box);

            list_box.insert (menu_item, i);
        }

        list_box.row_activated.connect ((row) => {
            stack.set_visible_child_name ("%d".printf (row.get_index ()));
            var view = stack.get_visible_child ();
            (view as Widgets.MessengerView).model.unread_notifications = 0;
        });

        var scroll = new Gtk.ScrolledWindow (null, null);
        scroll.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroll.expand = true;
        scroll.add (list_box);

        grid.add (scroll);

        pack1 (grid, false, false);
        pack2 (stack, true, false);
        show_all ();
    }
}
