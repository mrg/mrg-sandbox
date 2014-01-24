package t54.app.components;

import java.util.ArrayList;
import java.util.List;

import org.apache.tapestry5.BindingConstants;
import org.apache.tapestry5.ComponentResources;
import org.apache.tapestry5.MarkupWriter;
import org.apache.tapestry5.annotations.Import;
import org.apache.tapestry5.annotations.Parameter;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.runtime.RenderCommand;
import org.apache.tapestry5.runtime.RenderQueue;
import org.apache.tapestry5.services.Environment;
import org.apache.tapestry5.services.javascript.JavaScriptSupport;

import t54.models.TabTracker;

@Import(module="bootstrap/tab", stylesheet="css/tabs.less")
public class TabGroup
{
    @Parameter(defaultPrefix=BindingConstants.LITERAL)
    @Property
    private String clientId;

    @Property
    private List<String> tabIds;

    @Property
    private String tabId;

    @Property
    private int tabNum;

    @Property
    private String tabGroupId;

    // Work fields

    private TabTracker tabTracker;

    private List<String> tabTitles;
    private List<String> tabRequiredIndicators;
    private List<String> tabMarkups;

    // Generally useful bits and pieces

    @Inject
    private Environment environment;

    @Inject
    private JavaScriptSupport javaScriptSupport;

    @Inject
    private ComponentResources componentResources;

    // The code

    /**
     * The tricky part is that we can't render the tabs before we've rendered
     * the body, because we don't know how many elements are in the body nor
     * what labels they would like. We solve this by making a TabTracker
     * available to the body. The Tabs in the body will record, in TabTracker,
     * the labels and markup they want. Later, in our afterRenderBody(), we will
     * get those labels and markup from TabTracker, then render the whole
     * TabGroup at once.
     */
    void beginRender()
    {
        if (clientId == null)
            tabGroupId = javaScriptSupport.allocateClientId(componentResources);
        else
            tabGroupId = javaScriptSupport.allocateClientId(clientId);

        environment.push(TabTracker.class, new TabTracker());
    }

    /**
     * By the time this method is called, we expect each Tab in the body of this
     * component to have recorded, in TabTracker, the tab labels and markup that
     * it wants, and to have deleted from the DOM any markup it generated. Using
     * what's in TabTracker we can now render a navbar with appropriate labels,
     * then render the markups below it.
     */
    void afterRenderBody(MarkupWriter markupWriter)
    {
        tabTracker = environment.pop(TabTracker.class);

        tabTitles = tabTracker.getTitles();
        tabRequiredIndicators = tabTracker.getRequiredIndicators();
        tabMarkups = tabTracker.getMarkups();

        tabIds = new ArrayList<String>();

        for (int i = 0; i < tabTitles.size(); i++)
        {
//            String id = javaScriptSupport.allocateClientId(componentResources);
            String id = javaScriptSupport.allocateClientId(tabGroupId + "_tab");
            tabIds.add(id);
        }
    }

    void afterRender()
    {
        // We depend on http://getbootstrap.com/javascript/#tabs . We use its
        // Markup technique.
//        javaScriptSupport.require("bootstrap/tab");
        javaScriptSupport.require("TabGroup").invoke("ping").with(tabGroupId);
        javaScriptSupport.require("TabGroup").invoke("pong").with(tabGroupId);
    }

    public String getTabTitle()
    {
        return tabTitles.get(tabNum);
    }

    public String getTabRequiredIndicator()
    {
        return tabRequiredIndicators.get(tabNum);
    }

    public String getActive()
    {
        return tabNum == 0 ? "active" : "";
    }

    public RenderCommand getTabMarkup()
    {
        return new RenderCommand()
        {
            @Override
            public void render(MarkupWriter writer, RenderQueue queue)
            {
                writer.writeRaw(tabMarkups.get(tabNum));
            }
        };
    }
}
