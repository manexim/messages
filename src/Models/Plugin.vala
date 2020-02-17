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

public class Models.Plugin : Object {
    private string _id;
    private string _name;
    private string _url;
    private bool _enabled = false;
    private uint _unread_notifications = 0;

    public string id {
        get {
            return _id;
        }
        set {
            _id = value;
        }
    }

    public string name {
        get {
            return _name;
        }
        set {
            _name = value;
        }
    }

    public string url {
        get {
            return _url;
        }
        set {
            _url = value;
        }
    }

    public bool enabled {
        get {
            return _enabled;
        }
        set {
            _enabled = value;
        }
    }

    public uint unread_notifications {
        get {
            return _unread_notifications;
        }
        set {
            _unread_notifications = value;
        }
    }
}
