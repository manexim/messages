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
        position = 130;

        var source_list = new Granite.Widgets.SourceList ();
        var stack = new Gtk.Stack ();

        var plugins = Services.PluginManager.get_default ().enabled;
        for (var i = 0; i < plugins.length; i++) {
            var plugin = plugins.index (i);

            var view = new Widgets.PluginView (plugin);
            stack.add_named (view, plugin.id);

            var menu_item = new Granite.Widgets.SourceList.Item (plugin.name);
            menu_item.badge = (plugin.unread_notifications > 0) ? "%u".printf (plugin.unread_notifications) : "";
            menu_item.icon = Utilities.load_shared_icon (plugin.id);
            source_list.root.add (menu_item);

            plugin.notify.connect (() => {
                debug ("[%s] unread_notifications: %u", plugin.id, plugin.unread_notifications);

                if (stack.get_visible_child () != view) {
                    menu_item.badge =
                        (plugin.unread_notifications > 0) ? "%u".printf (plugin.unread_notifications) : "";
                } else if (plugin.unread_notifications == 0) {
                    menu_item.badge = "";
                }

                update_app_badge ();
            });
        }

        Services.PluginManager.get_default ().notify["visible"].connect (() => {
            var visible = Services.PluginManager.get_default ().visible;
            Models.Plugin? plugin = null;
            for (var i = 0; i < plugins.length; i++) {
                if (visible == plugins.index (i).id) {
                    plugin = plugins.index (i);
                    break;
                }
            }

            if (plugin == null) {
                return;
            };

            foreach (var item in source_list.root.children) {
                if (item.name == plugin.name) {
                    source_list.scroll_to_item (item);
                    source_list.selected = item;
                    break;
                }
            }
        });

        pack1 (source_list, false, false);
        add2 (stack);

        source_list.item_selected.connect ((item) => {
            if (item == null) {
                return;
            }

            for (var i = 0; i < plugins.length; i++) {
                var plugin = plugins.index (i);
                if (item.name == plugin.name) {
                    stack.set_visible_child_name (plugin.id);
                    plugin.unread_notifications = 0;
                    break;
                }
            }

            if (item.badge != "" && item.badge != null) {
                item.badge = "";
            }

            update_app_badge ();
        });
    }

    private void update_app_badge () {
        uint unread_notifications_sum = 0;
        var plugins = Services.PluginManager.get_default ().enabled;
        foreach (var m in plugins.data) {
            unread_notifications_sum += m.unread_notifications;
        }

        Granite.Services.Application.set_badge.begin (unread_notifications_sum, (obj, res) => {
            try {
                Granite.Services.Application.set_badge.end (res);
            } catch (GLib.Error e) {
                critical (e.message);
            }
        });

        Granite.Services.Application.set_badge_visible.begin (unread_notifications_sum != 0U, (obj, res) => {
            try {
                Granite.Services.Application.set_badge_visible.end (res);
            } catch (GLib.Error e) {
                critical (e.message);
            }
        });
    }
}
