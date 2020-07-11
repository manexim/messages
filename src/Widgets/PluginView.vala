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

public class Widgets.PluginView : WebKit.WebView {
    private Models.Plugin plugin;
    private GLib.Icon icon;

    public PluginView (Models.Plugin plugin) {
        this.plugin = plugin;
        this.icon = Utilities.load_shared_icon (this.plugin.id);

        web_context.initialize_notification_permissions.connect (() => {
            var allowed_origins = new List<WebKit.SecurityOrigin> ();
            allowed_origins.append (new WebKit.SecurityOrigin.for_uri (this.plugin.url));
            var disallowed_origins = new List<WebKit.SecurityOrigin> ();

            web_context.init_notification_permissions (allowed_origins, disallowed_origins);
        });

        show_notification.connect ((notification) => {
            var native_notification = new GLib.Notification (notification.title);
            native_notification.set_body (notification.body);
            native_notification.set_icon (this.icon);
            Variant target = new Variant.string (this.plugin.id);
            native_notification.set_default_action_and_target_value ("app.show-tab", target);
            Application.instance.send_notification (this.plugin.id, native_notification);

            this.plugin.unread_notifications += 1;

            debug ("[%s] got notification".printf (this.plugin.id));

            return true;
        });

        load_uri (this.plugin.url);
    }

    construct {
        var webkit_settings = new WebKit.Settings () {
            default_font_family = Gtk.Settings.get_default ().gtk_font_name,
            enable_accelerated_2d_canvas = true,
            enable_back_forward_navigation_gestures = true,
            enable_dns_prefetching = true,
            enable_html5_database = true,
            enable_html5_local_storage = true,
            enable_javascript = true,
            enable_page_cache = true,
            enable_plugins = true,
            enable_smooth_scrolling = true,
            enable_webgl = true,
            hardware_acceleration_policy = WebKit.HardwareAccelerationPolicy.ALWAYS
        };

        settings = webkit_settings;
        web_context = new WebContext ();

        context_menu.connect (on_context_menu);
    }

    public Models.Plugin model {
        get {
            return this.plugin;
        }
    }

    private bool on_context_menu (
        WebKit.ContextMenu context_menu,
        Gdk.Event event,
        WebKit.HitTestResult hit_test_result
    ) {
        // Disable context menu
        return true;
    }
}
