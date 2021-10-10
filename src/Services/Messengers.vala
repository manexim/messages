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

public class Services.Messengers : Object {
    public signal void on_added (Models.Messenger messenger);
    public signal void on_removed (Models.Messenger messenger);

    private static Messengers instance;

    public Array<Models.Messenger> available { get; private set; }
    public Array<Models.Messenger> configured { get; private set; }
    public string visible { get; set; }

    public static Messengers get_default () {
        if (instance == null) {
            instance = new Messengers ();
        }

        return instance;
    }

    public void add (Models.Messenger messenger) {
        configured.append_val (messenger);

        //  for (var i = 0; i < available.length; i++) {
        //      var a = available.index (i);

        //      if (a.id == messenger.id) {
        //          available.remove_index (i);
        //          break;
        //      }
        //  }

        on_added (messenger);
    }

    public void remove (Models.Messenger messenger) {
        for (var i = 0; i < configured.length; i++) {
            var c = configured.index (i);

            if (c.id == messenger.id) {
                configured.remove_index (i);
                break;
            }
        }

        //  available.append_val (messenger);

        on_removed (messenger);
    }

    public void update (string name, Models.Messenger messenger) {
        for (var i = 0; i < configured.length; i++) {
            var c = configured.index (i);

            if (c.name == name) {
                configured.data[i] = messenger;
                break;
            }
        }
    }

    private Messengers () {
        available = new Array<Models.Messenger> ();
        configured = new Array<Models.Messenger> ();

        {
            var messenger = new Models.Messenger ();
            messenger.id = "com.messenger";
            messenger.name = "Messenger";
            messenger.url = "https://www.messenger.com/";
            available.append_val (messenger);
        }

        {
            var messenger = new Models.Messenger ();
            messenger.id = "com.slack";
            messenger.name = "Slack";
            messenger.url = "https://slack.com/";
            available.append_val (messenger);
        }

        {
            var messenger = new Models.Messenger ();
            messenger.id = "org.telegram.web";
            messenger.name = "Telegram";
            messenger.url = "https://web.telegram.org/";
            available.append_val (messenger);
        }

        {
            var messenger = new Models.Messenger ();
            messenger.id = "co.tinode.web";
            messenger.name = "Tinode";
            messenger.url = "http://web.tinode.co/";
            available.append_val (messenger);
        }

        {
            var messenger = new Models.Messenger ();
            messenger.id = "com.whatsapp.web";
            messenger.name = "WhatsApp";
            messenger.url = "https://web.whatsapp.com/";
            available.append_val (messenger);
        }

        var path = File.new_build_filename (
            Environment.get_user_data_dir (),
            Config.APP_ID,
            Config.APP_ID + ".ini"
        ).get_path ();
        var key_file = new KeyFile ();

        if (key_file.load_from_file (path, KeyFileFlags.NONE)) {
            foreach (unowned string group in key_file.get_groups ()) {
                if (key_file.has_key (group, "name") && key_file.has_key (group, "url")) {
                    var messenger = new Models.Messenger () {
                        id = group,
                        name = key_file.get_string (group, "name"),
                        url = key_file.get_string (group, "url")
                    };
                    configured.append_val (messenger);
                }
            }
        }
    }

    public void save () {
        var path = File.new_build_filename (
            Environment.get_user_data_dir (),
            Config.APP_ID,
            Config.APP_ID + ".ini"
        ).get_path ();
        var key_file = new KeyFile ();

        foreach (var messenger in configured.data) {
            key_file.set_string (messenger.id, "name", messenger.name);
            key_file.set_string (messenger.id, "url", messenger.url);
        }

        key_file.save_to_file (path);
    }
}
