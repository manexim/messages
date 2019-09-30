public class Application : Granite.Application {
    private MainWindow window;

    public Application () {
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
        var app = new Application ();

        return app.run (args);
    }
}
