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

public class Widgets.MessengerView : WebKit.WebView {
    private Models.Messenger messenger;
    private GLib.Icon icon;

    public MessengerView (Models.Messenger messenger) {
        this.messenger = messenger;
        this.icon = Utilities.load_shared_icon (this.messenger.id);

        var settings = this.get_settings ();
        settings.enable_plugins = true;
        settings.enable_javascript = true;
        settings.enable_html5_database = true;
        settings.enable_html5_local_storage = true;

        web_context.initialize_notification_permissions.connect (() => {
            var allowed_origins = new List<WebKit.SecurityOrigin> ();
            allowed_origins.append (new WebKit.SecurityOrigin.for_uri (this.messenger.url));
            var disallowed_origins = new List<WebKit.SecurityOrigin> ();

            web_context.init_notification_permissions (allowed_origins, disallowed_origins);
        });

        show_notification.connect ((notification) => {
            var native_notification = new GLib.Notification (notification.title);
            native_notification.set_body (notification.body);
            native_notification.set_icon (this.icon);
            Application.instance.send_notification (this.messenger.id, native_notification);

            this.messenger.unread_notifications += 1;

            debug ("[%s] got notification".printf (this.messenger.id));

            return true;
        });

        load_uri (this.messenger.url);
    }

    public Models.Messenger model {
        get {
            return this.messenger;
        }
    }
}
