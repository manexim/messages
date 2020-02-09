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

        stack.add_named (new Widgets.WebView ("https://www.messenger.com/"), "0");
        stack.add_named (new Widgets.WebView ("https://slack.com/signin/"), "1");
        stack.add_named (new Widgets.WebView ("https://web.telegram.org/"), "2");
        stack.add_named (new Widgets.WebView ("https://web.whatsapp.com/"), "3");

        grid.orientation = Gtk.Orientation.VERTICAL;
        var list_box = new Gtk.ListBox ();
        list_box.selection_mode = Gtk.SelectionMode.SINGLE;
        list_box.activate_on_single_click = true;

        list_box.insert (new Gtk.MenuItem.with_label ("Messenger"), 0);
        list_box.insert (new Gtk.MenuItem.with_label ("Slack"), 1);
        list_box.insert (new Gtk.MenuItem.with_label ("Telegram"), 2);
        list_box.insert (new Gtk.MenuItem.with_label ("WhatsApp"), 3);

        list_box.row_activated.connect ((row) => {
            stack.set_visible_child_name ("%d".printf (row.get_index ()));
        });

        var scroll = new Gtk.ScrolledWindow (null, null);
        scroll.set_size_request (150, 150);
        scroll.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroll.expand = true;
        scroll.add (list_box);

        grid.add (scroll);

        pack1 (grid, false, false);
        pack2 (stack, true, false);
        show_all ();
    }
}
