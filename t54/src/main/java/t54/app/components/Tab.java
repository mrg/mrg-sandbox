package t54.app.components;

import org.apache.tapestry5.BindingConstants;
import org.apache.tapestry5.ComponentResources;
import org.apache.tapestry5.MarkupWriter;
import org.apache.tapestry5.annotations.Environmental;
import org.apache.tapestry5.annotations.Parameter;
import org.apache.tapestry5.dom.Element;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.services.Request;

import t54.models.TabTracker;

public class Tab
{
    @Parameter( allowNull = false, defaultPrefix = BindingConstants.LITERAL, required = true)
    private String title;

    @Inject
    private ComponentResources componentResources;

    @Environmental
    private TabTracker tabTracker;

    @Inject
    private Request request;

    void beforeRenderBody(MarkupWriter writer)
    {
        // Make a container for the tab body.

        writer.element("div");
    }

    void afterRenderBody(MarkupWriter writer)
    {
        // End the container and record the label the body's markup in the
        // TabTracker.

        Element bodyContainer = writer.getElement();
        writer.end();
        tabTracker.addTab(title, bodyContainer.getChildMarkup());

        // Remove the container (and therefore the body's markup) from the DOM.
        // TabGroup will render the markup later at
        // its leisure.

        bodyContainer.remove();
    }
}
