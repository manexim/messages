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

    private Application () {
        Object (
            application_id: Config.APP_ID,
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        window = new MainWindow (this);

        window.show_all ();
    }

    public static int main (string[] args) {
        var app = Application.instance;

        return app.run (args);
    }
}
