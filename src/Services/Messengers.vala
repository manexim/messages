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
    private Models.Messenger[] _data;
    private string _visible;

    public static Messengers get_default () {
        if (instance == null) {
            instance = new Messengers ();
        }

        return instance;
    }

    public Models.Messenger[] data {
        get {
            return _data;
        }
    }

    public string visible {
        get {
            return _visible;
        }
        set {
            foreach (var m in _data) {
                if (m.id == value) {
                    _visible = value;
                    break;
                }
            }
        }
    }

    private Messengers () {
        _data = new Models.Messenger[4];
        _data[0] = new Models.Messenger ();
        _data[0].id = "com.messenger";
        _data[0].name = "Messenger";
        _data[0].url = "https://www.messenger.com/";

        _data[1] = new Models.Messenger ();
        _data[1].id = "com.slack";
        _data[1].name = "Slack";
        _data[1].url = "https://slack.com/signin/";

        _data[2] = new Models.Messenger ();
        _data[2].id = "org.telegram.web";
        _data[2].name = "Telegram";
        _data[2].url = "https://web.telegram.org/";

        _data[3] = new Models.Messenger ();
        _data[3].id = "com.whatsapp.web";
        _data[3].name = "WhatsApp";
        _data[3].url = "https://web.whatsapp.com/";
    }
}
