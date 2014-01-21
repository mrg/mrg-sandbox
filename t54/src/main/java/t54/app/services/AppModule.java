package t54.app.services;

import org.apache.commons.lang.BooleanUtils;
import org.apache.tapestry5.SymbolConstants;
import org.apache.tapestry5.ioc.MappedConfiguration;
import org.apache.tapestry5.ioc.ServiceBinder;
import org.apache.tapestry5.ioc.annotations.Contribute;
import org.apache.tapestry5.ioc.annotations.Startup;
import org.apache.tapestry5.services.compatibility.Compatibility;
import org.apache.tapestry5.services.compatibility.Trait;
import org.apache.tapestry5.services.javascript.JavaScriptStack;
import org.apache.tapestry5.services.javascript.JavaScriptStackSource;

public class AppModule
{
    @Startup
    public void initializeDatabase()
    {
        // DataContext context = DataContext.createDataContext();
        // DataSource dataSource =
        // context.getParentDataDomain().getNode("CBE").getDataSource();
        // //.getConnection();
        // Flyway flyway = new Flyway();
        //
        // flyway.setDataSource(dataSource);
        // flyway.setInitialVersion("1.0");
        // flyway.setInitOnMigrate(true);
        // flyway.setTarget(MigrationVersion.LATEST);
        // flyway.migrate();
    }

    public static void bind(ServiceBinder binder)
    {
    }

    @Contribute(JavaScriptStackSource.class)
    public static void addStacks(MappedConfiguration<String, JavaScriptStack> configuration)
    {
//        configuration.addInstance("site", SiteStack.class);
    }

    
    @Contribute(Compatibility.class)
    public static void disableScriptaculous(MappedConfiguration configuration)
    {
        configuration.add(Trait.SCRIPTACULOUS, false);
        configuration.add(Trait.INITIALIZERS, false);
    }

    public static void contributeApplicationDefaults(MappedConfiguration<String, String> configuration)
    {
        boolean productionMode = BooleanUtils.toBoolean(System.getProperty(SymbolConstants.PRODUCTION_MODE));

        configuration.add(SymbolConstants.SUPPORTED_LOCALES, "en");
        configuration.add(SymbolConstants.APPLICATION_VERSION, "T54-1.0");
        configuration.add(SymbolConstants.JAVASCRIPT_INFRASTRUCTURE_PROVIDER, "jquery");
        configuration.add(SymbolConstants.HMAC_PASSPHRASE, "Bend it like Bender!");
    }
}
