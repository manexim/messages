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

public class Services.PluginManager : Object {
    private static PluginManager instance;
    private Array<Models.Plugin> _data;
    private string _visible;

    public static PluginManager get_default () {
        if (instance == null) {
            instance = new PluginManager ();
        }

        return instance;
    }

    public Array<Models.Plugin> data {
        get {
            return _data;
        }
    }

    public string visible {
        get {
            return _visible;
        }
        set {
            foreach (var m in _data.data) {
                if (m.id == value) {
                    _visible = value;
                    break;
                }
            }
        }
    }

    private PluginManager () {
        _data = new Array<Models.Plugin> ();

        {
            var plugin = new Models.Plugin ();
            plugin.id = "com.messenger";
            plugin.name = "Messenger";
            plugin.url = "https://www.messenger.com/";
            _data.append_val (plugin);
        }

        {
            var plugin = new Models.Plugin ();
            plugin.id = "com.slack";
            plugin.name = "Slack";
            plugin.url = "https://slack.com/signin/";
            _data.append_val (plugin);
        }

        {
            var plugin = new Models.Plugin ();
            plugin.id = "org.telegram.web";
            plugin.name = "Telegram";
            plugin.url = "https://web.telegram.org/";
            _data.append_val (plugin);
        }

        {
            var plugin = new Models.Plugin ();
            plugin.id = "com.whatsapp.web";
            plugin.name = "WhatsApp";
            plugin.url = "https://web.whatsapp.com/";
            _data.append_val (plugin);
        }
    }
}
