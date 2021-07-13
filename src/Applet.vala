// Copyright (c) 2021 Akira Miyakoda
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

namespace HostnameApplet
{

public class Plugin : Budgie.Plugin, Peas.ExtensionBase
{
    public Budgie.Applet get_panel_widget(string uuid)
    {
        return new HostnameApplet.Applet(uuid);
    }
}

public class Applet : Budgie.Applet
{
    const int HOST_NAME_MAX = 64;

    public string uuid { public set; public get; }

    private Gtk.EventBox applet_container;
    private Gtk.Label    hostname_label;
    private Budgie.PanelPosition panel_position;

    private Settings settings;

    public Applet(string uuid)
    {
        Object(uuid: uuid);

        // Setup settings
        this.settings_schema = "com.github.akiramiyakoda.budgie-hostname-applet";
        this.settings_prefix = "/com/github/akiramiyakoda/budgie-hostname-applet";

        this.settings = this.get_applet_settings(uuid);
        this.settings.changed.connect((key) => {
            update_all();
        });

        // Setup the applet
        this.hostname_label = new Gtk.Label("");
        this.hostname_label.get_style_context().add_class("budgie-hostname-applet");

        this.applet_container = new Gtk.EventBox();
        this.applet_container.add(this.hostname_label);

        this.add(this.applet_container);
        this.panel_position_changed(Budgie.PanelPosition.TOP);

        this.update_css_styles();

        this.update_all();
        this.show_all();
    }

    private void update_all()
    {
        // update the orientation
        switch (this.panel_position) {
            case Budgie.PanelPosition.LEFT:
                this.hostname_label.angle = 90;
                break;
            case Budgie.PanelPosition.RIGHT:
                this.hostname_label.angle = 270;
                break;
            default:
                this.hostname_label.angle = 0;
                break;
        }

        // Update the text
        var show_custom = this.settings.get_boolean("show-custom-text");
        if (show_custom) {
            this.hostname_label.label = this.settings.get_string("custom-text");
        }
        else {
            this.hostname_label.label = get_hostname();
        }

        // Update the CSS
        update_css_styles();
    }

    private string get_hostname()
    {
        char[] buf = new char[ HOST_NAME_MAX + 1 ];
        Posix.gethostname(buf);

        return (string)buf;
    }

    public override void panel_position_changed(Budgie.PanelPosition position)
    {
        this.panel_position = position;
        this.update_all();
    }

    public override bool supports_settings()
    {
        return true;
    }

    public override Gtk.Widget? get_settings_ui()
    {
        return new AppletSettings(this.get_applet_settings(uuid));
    }

    private void update_css_styles()
    {
        var css = new StringBuilder();
        css.append(".budgie-hostname-applet {");

        var underline = this.settings.get_boolean("show-underline");
        css.append_printf("text-decoration-line: %s;", underline ? "underline" : "inherit");

        var bold = this.settings.get_boolean("use-bold-font");
        css.append_printf("font-weight: %s;", bold ? "bold" : "inherit");

        if (this.settings.get_boolean("use-custom-color")) {
            css.append_printf("color: %s;", this.settings.get_string("custom-color"));
        }
        else {
            css.append("color: inherit");
        }

        css.append("}");

        var screen = this.get_screen();
        var css_provider = new Gtk.CssProvider();
        try {
            css_provider.load_from_data(css.str);
            Gtk.StyleContext.add_provider_for_screen(screen, css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
        }
        catch (Error e) {
            message("Could not load css %s", e.message);
        }
    }

}

}

[ModuleInit]
public void peas_register_types(TypeModule module)
{
    // boilerplate - all modules need this
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type(typeof(Budgie.Plugin), typeof(HostnameApplet.Plugin));
}
