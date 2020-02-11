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

namespace Utilities {
    GLib.Icon? load_shared_icon (string name) {
        foreach (string dir in GLib.Environment.get_system_data_dirs ()) {
            string path = GLib.Path.build_filename (dir, Config.APP_ID, "icons", name + ".svg");
            debug ("Searching in %s\n", path);
            File file = File.new_for_path (path);
            if (file.query_exists ()) {
                try {
                    debug ("Found icon: %s\n", path);
                    return new Gdk.Pixbuf.from_file_at_size (path, 24, 24);
                } catch (GLib.Error error) {
                    GLib.critical ("Could not load icon: %s\n", path);
                    GLib.critical ("%s\n", error.message);
                }
            }
        }

        return null;
    }
}
