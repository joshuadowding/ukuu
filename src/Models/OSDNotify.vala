/*
 * OSDNotify.vala
 *
 * Copyright 2012-2019 Tony George <teejeetech@gmail.com>
 * Copyright 2019-2020 Joshua Dowding <joshuadowding@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 */

using GLib;

// dep: notify-send
public class OSDNotify : GLib.Object {

    private static DateTime dt_last_notification = null;
    public const int NOTIFICATION_INTERVAL = 3;

    private ProcessHelper process_helper;

    public OSDNotify () {
        process_helper = new ProcessHelper ();
    }

    public int notify_send (string title, string message, int durationMillis,
                            string urgency = "low",        // low, normal, critical
                            string dialog_type = "info"        // error, info, warning
    ) {

        /* Displays notification bubble on the desktop */

        int retVal = 0;

        switch (dialog_type) {
            case "error":
            case "info":
            case "warning":
                // ok
                break;

            default:
                dialog_type = "info";
                break;
        }

        long seconds = 9999;
        if (dt_last_notification != null) {
            DateTime dt_end = new DateTime.now_local ();
            TimeSpan elapsed = dt_end.difference (dt_last_notification);
            seconds = (long) (elapsed * 1.0 / TimeSpan.SECOND);
        }

        if (seconds > NOTIFICATION_INTERVAL) {
            string s = "notify-send -t %d -u %s -i %s \"%s\" \"%s\"".printf (durationMillis, urgency, "gtk-dialog-" + dialog_type, title, message);
            retVal = process_helper.exec_sync (s, null, null);
            dt_last_notification = new DateTime.now_local ();
        }

        return retVal;
    }
}
