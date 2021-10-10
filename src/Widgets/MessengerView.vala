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

public class Widgets.MessengerView : WebKit.WebView {
    public Models.Messenger messenger { get; construct set; }
    private GLib.Icon icon;

    public MessengerView (Models.Messenger messenger) {
        Object (
            messenger: messenger
        );

        icon = Utilities.load_shared_icon (messenger.id);

        var webkit_settings = new WebKit.Settings () {
            default_font_family = Gtk.Settings.get_default ().gtk_font_name,
            enable_html5_database = true,
            enable_html5_local_storage = true,
            enable_javascript = true,
            enable_page_cache = true,
            enable_smooth_scrolling = true
        };
        settings = webkit_settings;

        web_context.set_process_model (WebKit.ProcessModel.MULTIPLE_SECONDARY_PROCESSES);
        web_context.get_cookie_manager ().set_accept_policy (WebKit.CookieAcceptPolicy.ALWAYS);

        web_context.initialize_notification_permissions.connect (() => {
            var allowed_origins = new List<WebKit.SecurityOrigin> ();
            allowed_origins.append (new WebKit.SecurityOrigin.for_uri (this.messenger.url));
            var disallowed_origins = new List<WebKit.SecurityOrigin> ();

            web_context.init_notification_permissions (allowed_origins, disallowed_origins);
        });

        show_notification.connect ((notification) => {
            var native_notification = new GLib.Notification (notification.title);
            native_notification.set_body (notification.body);
            native_notification.set_icon (icon);
            Variant target = new Variant.string (messenger.id);
            native_notification.set_default_action_and_target_value ("app.show-messenger", target);
            Application.instance.send_notification (messenger.id, native_notification);

            messenger.unread_notifications += 1;

            debug ("[%s] got notification".printf (messenger.id));

            return true;
        });

        context_menu.connect ((context_menu, event, hit_test_result) => {
            return true; // block context menu
        });

        load_uri (this.messenger.url);
    }
}
