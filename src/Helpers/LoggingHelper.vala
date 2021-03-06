/*
 * TeeJee.Logging.vala
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

public class LoggingHelper : GLib.Object {

    /* Functions for logging messages to console and log files */

    public DataOutputStream dos_log;
    public string err_log;
    public bool LOG_ENABLE = true;
    public bool LOG_TIMESTAMP = false;
    public bool LOG_COLORS = true;
    public bool LOG_DEBUG = false;
    public bool LOG_COMMANDS = false;

    public LoggingHelper () {
    }

    public void log_msg (string message, bool highlight = false) {
        MiscHelper misc_helper = new MiscHelper ();

        if (!LOG_ENABLE) {
            return;
        }

        string msg = "";

        if (highlight && LOG_COLORS) {
            msg += "\033[1;38;5;34m";
        }

        if (LOG_TIMESTAMP) {
            msg += "[" + misc_helper.timestamp (true) + "] ";
        }

        msg += message;

        if (highlight && LOG_COLORS) {
            msg += "\033[0m";
        }

        msg += "\n";

        stdout.printf (msg);
        stdout.flush ();

        try {
            if (dos_log != null) {
                dos_log.put_string ("[%s] %s\n".printf (misc_helper.timestamp (), message));
            }
        } catch (Error e) {
            stdout.printf (e.message);
        }
    }

    public void log_error (string message, bool highlight = false, bool is_warning = false) {
        MiscHelper misc_helper = new MiscHelper ();

        if (!LOG_ENABLE) {
            return;
        }

        string msg = "";

        if (highlight && LOG_COLORS) {
            msg += "\033[1;38;5;160m";
        }

        if (LOG_TIMESTAMP) {
            msg += "[" + misc_helper.timestamp (true) + "] ";
        }

        string prefix = (is_warning) ? _("W") : _("E");

        msg += prefix + ": " + message;

        if (highlight && LOG_COLORS) {
            msg += "\033[0m";
        }

        msg += "\n";

        stdout.printf (msg);
        stdout.flush ();

        try {
            string str = "[%s] %s: %s\n".printf (misc_helper.timestamp (), prefix, message);

            if (dos_log != null) {
                dos_log.put_string (str);
            }

            if (err_log != null) {
                err_log += "%s\n".printf (message);
            }
        } catch (Error e) {
            stdout.printf (e.message);
        }
    }

    public void log_debug (string message) {
        MiscHelper misc_helper = new MiscHelper ();

        if (!LOG_ENABLE) {
            return;
        }

        if (LOG_DEBUG) {
            log_msg ("D: " + message);
        }

        try {
            if (dos_log != null) {
                dos_log.put_string ("[%s] %s\n".printf (misc_helper.timestamp (), message));
            }
        } catch (Error e) {
            stdout.printf (e.message);
        }
    }

    public void log_draw_line () {
        log_msg (string.nfill (70, '='));
    }
}
