// Copyright (c) 2021 Akira Miyakoda
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

namespace HostnameApplet
{

public class AppletSettings : Gtk.Box
{
    const int HORIZONTAL_SPACING = 12;
    const int VERTICAL_SPACING   = 12;
    const int CUSTOM_STRING_MAX_LENGTH = 64;

    private Settings settings;

    private Gtk.Switch      switch_custom_text;
    private Gtk.Entry       entry_custom_text;
    private Gtk.Switch      switch_underline;
    private Gtk.Switch      switch_bold;
    private Gtk.Switch      switch_custom_color;
    private Gtk.ColorButton button_custom_color;

    public AppletSettings(Settings settings)
    {
        this.settings = settings;

        this.orientation = Gtk.Orientation.VERTICAL;
        this.spacing     = VERTICAL_SPACING;

        {
            var label = new Gtk.Label(_ ("Show Custom Text"));
            label.halign = Gtk.Align.START;
            label.valign = Gtk.Align.CENTER;

            this.switch_custom_text = new Gtk.Switch();
            this.switch_custom_text.halign = Gtk.Align.END;
            this.switch_custom_text.valign = Gtk.Align.CENTER;

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, HORIZONTAL_SPACING);
            box.pack_start(label);
            box.pack_start(this.switch_custom_text);

            this.pack_start(box);
        }

        {
            var label = new Gtk.Label(_ ("Custom Text"));
            label.halign = Gtk.Align.START;
            label.valign = Gtk.Align.CENTER;

            this.entry_custom_text = new Gtk.Entry();
            this.entry_custom_text.max_length = CUSTOM_STRING_MAX_LENGTH;
            this.entry_custom_text.halign = Gtk.Align.END;
            this.entry_custom_text.valign = Gtk.Align.CENTER;

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, HORIZONTAL_SPACING);
            box.pack_start(label);
            box.pack_start(this.entry_custom_text);

            this.pack_start(box);
        }

        {
            var label = new Gtk.Label(_ ("Underline"));
            label.halign = Gtk.Align.START;
            label.valign = Gtk.Align.CENTER;

            this.switch_underline = new Gtk.Switch();
            this.switch_underline.halign = Gtk.Align.END;
            this.switch_underline.valign = Gtk.Align.CENTER;

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, HORIZONTAL_SPACING);
            box.pack_start(label);
            box.pack_start(this.switch_underline);

            this.pack_start(box);
        }

        {
            var label = new Gtk.Label(_ ("Bold"));
            label.halign = Gtk.Align.START;
            label.valign = Gtk.Align.CENTER;

            this.switch_bold = new Gtk.Switch();
            this.switch_bold.halign = Gtk.Align.END;
            this.switch_bold.valign = Gtk.Align.CENTER;

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, HORIZONTAL_SPACING);
            box.pack_start(label);
            box.pack_start(this.switch_bold);

            this.pack_start(box);
        }

        {
            var label = new Gtk.Label(_ ("Use Custom Color"));
            label.halign = Gtk.Align.START;
            label.valign = Gtk.Align.CENTER;

            this.switch_custom_color = new Gtk.Switch();
            this.switch_custom_color.halign = Gtk.Align.END;
            this.switch_custom_color.valign = Gtk.Align.CENTER;

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, HORIZONTAL_SPACING);
            box.pack_start(label);
            box.pack_start(this.switch_custom_color);

            this.pack_start(box);
        }

        {
            var label = new Gtk.Label(_ ("Custom Color"));
            label.halign = Gtk.Align.START;
            label.valign = Gtk.Align.CENTER;

            this.button_custom_color = new Gtk.ColorButton();
            this.button_custom_color.halign = Gtk.Align.END;
            this.button_custom_color.valign = Gtk.Align.CENTER;
            this.button_custom_color.use_alpha = true;

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, HORIZONTAL_SPACING);
            box.pack_start(label);
            box.pack_start(this.button_custom_color);

            this.pack_start(box);

            this.button_custom_color.color_set.connect(() => {
                this.settings.set_string("custom-color", this.button_custom_color.rgba.to_string());
            });
        }

        this.settings.bind("show-custom-text", this.switch_custom_text,  "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("custom-text",      this.entry_custom_text,   "text",   SettingsBindFlags.DEFAULT);
        this.settings.bind("show-underline",   this.switch_underline,    "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("use-bold-font",    this.switch_bold,         "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("use-custom-color", this.switch_custom_color, "active", SettingsBindFlags.DEFAULT);

        this.settings.changed.connect((key) => { set_active_controls(); });
        set_active_controls();
    }

    private void set_active_controls()
    {
        this.entry_custom_text.sensitive   = this.settings.get_boolean("show-custom-text");
        this.button_custom_color.sensitive = this.settings.get_boolean("use-custom-color");

        var rgba = Gdk.RGBA();
        rgba.parse(this.settings.get_string("custom-color"));
        this.button_custom_color.set_rgba(rgba);
    }
}

}
