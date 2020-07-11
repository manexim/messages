public class Application : Granite.Application {
    private static Application? _instance;
    private MainWindow window;

    public static Application instance {
        get {
            if (_instance == null) {
                _instance = new Application ();
            }

            return _instance;
        }
    }

    construct {
        var action = new SimpleAction ("show-tab", VariantType.STRING);
        action.activate.connect ((parameter) => {
            this.hold ();
            string id = parameter.get_string ();
            Services.PluginManager.get_default ().visible = id;
            this.release ();
        });

        add_action (action);
    }

    private Application () {
        Object (
            application_id: Config.APP_ID,
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        window = new MainWindow (this);

        window.show_all ();

        var action_quit = new SimpleAction ("quit", null);
        add_action (action_quit);
        set_accels_for_action ("app.quit", {"<Ctrl>Q"});

        action_quit.activate.connect (() => {
            quit ();
        });
    }

    public static int main (string[] args) {
        var app = Application.instance;

        return app.run (args);
    }
}
