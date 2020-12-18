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

public class Services.Messengers : Object {
    private static Messengers instance;
    private Array<Models.Messenger> _data;
    private string _visible;

    public static Messengers get_default () {
        if (instance == null) {
            instance = new Messengers ();
        }

        return instance;
    }

    public Array<Models.Messenger> data {
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

    private Messengers () {
        _data = new Array<Models.Messenger> ();

        {
            var messenger = new Models.Messenger ();
            messenger.id = "com.messenger";
            messenger.name = "Messenger";
            messenger.url = "https://www.messenger.com/";
            _data.append_val (messenger);
        }

        {
            var messenger = new Models.Messenger ();
            messenger.id = "com.slack";
            messenger.name = "Slack";
            messenger.url = "https://slack.com/signin/";
            _data.append_val (messenger);
        }

        {
            var messenger = new Models.Messenger ();
            messenger.id = "org.telegram.web";
            messenger.name = "Telegram";
            messenger.url = "https://web.telegram.org/";
            _data.append_val (messenger);
        }

        {
            var messenger = new Models.Messenger ();
            messenger.id = "com.whatsapp.web";
            messenger.name = "WhatsApp";
            messenger.url = "https://web.whatsapp.com/";
            _data.append_val (messenger);
        }
        
        {
            var messenger = new Models.Messenger ();
            messenger.id = "co.tinode.web";
            messenger.name = "Tinode";
            messenger.url = "http://web.tinode.co/";
            _data.append_val (messenger);
        }
    }
}
