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

public class Views.MainView : Gtk.Paned {
    private Gtk.Stack stack;
    private Granite.Widgets.SourceList source_list;
    private Gtk.MenuButton remove_button;
    private Gtk.MenuButton settings_button;

    construct {
        stack = new Gtk.Stack ();

        var placeholder = new Granite.Widgets.AlertView (
            _("Connect Your Online Accounts"),
            _("Connect online accounts by clicking the icon in the toolbar below."),
            "preferences-desktop-online-accounts"
        );
        placeholder.show_all ();

        stack.add (placeholder);

        source_list = new Granite.Widgets.SourceList ();

        var configured_messengers = Services.Messengers.get_default ().configured;
        for (var i = 0; i < configured_messengers.length; i++) {
            var messenger = configured_messengers.index (i);

            add_messenger (messenger);
        }

        var add_messenger_grid = new Gtk.Grid () {
            margin_top = 3,
            margin_bottom = 3,
            orientation = Gtk.Orientation.VERTICAL
        };

        var add_messenger_popover = new Gtk.Popover (null);
        add_messenger_popover.add (add_messenger_grid);

        var available_messengers = Services.Messengers.get_default ().available;
        for (var i = 0; i < available_messengers.length; i++) {
            var messenger = available_messengers.index (i);

            var messenger_menuitem = new Widgets.MessengerMenuItem (
                messenger.id,
                messenger.name
            );

            messenger_menuitem.clicked.connect (() => {
                add_messenger_popover.popdown ();

                var messenger_add_dialog = new Dialogs.MessengerAddDialog ((Gtk.Window) this.get_toplevel (), messenger);
                messenger_add_dialog.response.connect ((response_id) => {
                    if (response_id == Gtk.ResponseType.OK) {
                        var view = stack.get_child_by_name (messenger.name);
                        stack.remove (view);

                        view = new Widgets.MessengerView (messenger);
                        stack.add_named (view, messenger.name);
                    }
                });
                messenger_add_dialog.present ();
            });

            add_messenger_grid.add (messenger_menuitem);
        }

        add_messenger_grid.show_all ();

        var add_button = new Gtk.MenuButton () {
            always_show_image = true,
            image = new Gtk.Image.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = _("Add Messenger…"),
            popover = add_messenger_popover
        };
        add_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        remove_button = new Gtk.MenuButton () {
            always_show_image = true,
            image = new Gtk.Image.from_icon_name ("list-remove-symbolic", Gtk.IconSize.SMALL_TOOLBAR),
            sensitive = false
        };
        remove_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        remove_button.clicked.connect (() => {
            var item = source_list.selected;
            if (item == null) {
                return;
            }

            var icon_name = "";

            var messengers = Services.Messengers.get_default ().configured;
            for (var i = 0; i < messengers.length; i++) {
                var messenger = messengers.index (i);

                if (item.name == messenger.name) {
                    icon_name = messenger.id;
                    break;
                }
            }

            var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
                _("Remove »%s«").printf (source_list.selected.name),
                _("Are you sure you want to remove »%s«?").printf (source_list.selected.name),
                icon_name,
                Gtk.ButtonsType.CANCEL
            ) {
                transient_for = (Gtk.Window) this.get_toplevel ()
            };

            var suggested_button = new Gtk.Button.with_label ("Delete");
            suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
            message_dialog.add_action_widget (suggested_button, Gtk.ResponseType.ACCEPT);

            message_dialog.show_all ();
            message_dialog.response.connect ((response_id) => {
                if (response_id == Gtk.ResponseType.ACCEPT) {
                    delete_current_entry ();
                }

               message_dialog.destroy ();
            });
        });

        settings_button = new Gtk.MenuButton () {
            always_show_image = true,
            image = new Gtk.Image.from_icon_name ("preferences-system-symbolic", Gtk.IconSize.SMALL_TOOLBAR),
            sensitive = false
        };
        remove_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        settings_button.clicked.connect (() => {
            if (source_list.selected == null) {
                return;
            }

            var messengers = Services.Messengers.get_default ().configured;
            for (var i = 0; i < messengers.length; i++) {
                var messenger = messengers.index (i);

                if (source_list.selected.name == messenger.name) {
                    var messenger_update_dialog = new Dialogs.MessengerUpdateDialog ((Gtk.Window) this.get_toplevel (), messenger);
                    messenger_update_dialog.present ();
                    break;
                }
            }
        });

        var action_bar = new Gtk.ActionBar ();
        action_bar.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        action_bar.add (add_button);
        action_bar.add (remove_button);
        action_bar.add (settings_button);

        var sidebar = new Gtk.Grid ();
        sidebar.orientation = Gtk.Orientation.VERTICAL;
        sidebar.get_style_context ().add_class (Gtk.STYLE_CLASS_SIDEBAR);
        sidebar.add (source_list);
        sidebar.add (action_bar);

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        paned.position = 130;
        paned.pack1 (sidebar, false, false);
        paned.add2 (stack);

        add (paned);

        source_list.item_selected.connect ((item) => {
            update_buttons ();

            if (item == null) {
                return;
            }

            if (item.badge != "" && item.badge != null) {
                item.badge = "";
            }

            var messengers = Services.Messengers.get_default ().configured;
            for (var i = 0; i < messengers.length; i++) {
                var messenger = messengers.index (i);

                if (item.name == messenger.name) {
                    Services.Messengers.get_default ().visible = messenger.name;
                    messenger.unread_notifications = 0;
                    break;
                }
            }

            stack.set_visible_child_name (item.name);
        });

        Services.Messengers.get_default ().notify["visible"].connect (() => {
            var visible = Services.Messengers.get_default ().visible;

            stack.set_visible_child_name (visible);
            stack.show_all ();
            var view = stack.get_visible_child ();
            if (view is Widgets.MessengerView) {
                ((Widgets.MessengerView) view).messenger.unread_notifications = 0;
            }

            var current_item = source_list.get_first_child (source_list.root);
            while (current_item != null) {
                if (current_item.name == visible) {
                    source_list.selected = current_item;
                    break;
                }

                current_item = source_list.get_next_item (current_item);
            }
        });

        Services.Messengers.get_default ().on_added.connect ((messenger) => {
            add_messenger (messenger);
        });
    }

    private void add_messenger (Models.Messenger messenger) {
        var messenger_item = new Granite.Widgets.SourceList.Item (messenger.name) {
            icon = Utilities.load_shared_icon (messenger.id),
            badge = (messenger.unread_notifications > 0) ? "%u".printf (messenger.unread_notifications) : ""
        };
        source_list.root.add (messenger_item);

        var view = new Widgets.MessengerView (messenger);
        stack.add_named (view, messenger.name);

        messenger.notify["unread-notifications"].connect (() => {
            debug ("[%s] unread_notifications: %u", messenger.id, messenger.unread_notifications);

            if (stack.get_visible_child () != view) {
                messenger_item.badge =
                    (messenger.unread_notifications > 0) ? "%u".printf (messenger.unread_notifications) : "";
            } else if (messenger.unread_notifications == 0) {
                messenger_item.badge = "";
            }

            uint unread_notifications_sum = 0;
            foreach (var m in Services.Messengers.get_default ().configured.data) {
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
        });
    }

    private void delete_current_entry () {
        var item = source_list.selected;
        if (item == null) {
            return;
        }

        var messengers = Services.Messengers.get_default ().configured;
        for (var i = 0; i < messengers.length; i++) {
            var messenger = messengers.index (i);

            if (item.name == messenger.name) {
                Services.Messengers.get_default ().remove (messenger);
                source_list.root.remove (item);

                var view = stack.get_child_by_name (item.name);
                stack.remove (view);

                update_buttons ();

                break;
            }
        }
    }

    private void update_buttons () {
        var item = source_list.selected;
        if (item == null || source_list.get_first_child (source_list.root) == null) {
            remove_button.sensitive = false;
            remove_button.tooltip_text = "";
            settings_button.sensitive = false;
            settings_button.tooltip_text = "";

            return;
        }

        remove_button.sensitive = true;
        remove_button.tooltip_text = _("Remove »%s«").printf (item.name);
        settings_button.sensitive = true;
        settings_button.tooltip_text = _("Configure »%s«").printf (item.name);
    }
}
